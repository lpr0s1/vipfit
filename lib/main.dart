import 'package:flutter/material.dart';

void main() {
  runApp(const VipFitApp());
}

/// --- STOCKAGE TEMPORAIRE SANS DÉPENDANCE ---
class LocalStorage {
  static final Map<String, dynamic> _storage = {};
  static void save(String key, dynamic value) => _storage[key] = value;
  static dynamic get(String key) => _storage[key];
}

class VipFitApp extends StatelessWidget {
  const VipFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VipFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080B10),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF66), 
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF121824),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingWizard(),
    );
  }
}

/// --- MODULE ONBOARDING ---
class OnboardingWizard extends StatefulWidget {
  const OnboardingWizard({super.key});

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  int age = 22;
  String sex = 'Homme';
  double weight = 70.0;
  double height = 175.0;
  String targetMuscle = 'Full body';

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      LocalStorage.save('age', age);
      LocalStorage.save('sex', sex);
      LocalStorage.save('weight', weight);
      LocalStorage.save('height', height);
      LocalStorage.save('targetMuscle', targetMuscle);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const VipFitHome()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de progression
              Row(
                children: List.generate(5, (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentStep ? const Color(0xFF00FF66) : Colors.white12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep(
                      title: "Quel est votre sexe ?",
                      child: Column(
                        children: ['Homme', 'Femme', 'Autre'].map((s) => _buildSelectionTile(s, sex, (val) => setState(() => sex = val))).toList(),
                      ),
                    ),
                    _buildStep(
                      title: "Quel âge avez-vous ?",
                      child: _buildSlider(age.toDouble(), 14, 99, "ans", (val) => setState(() => age = val.toInt())),
                    ),
                    _buildStep(
                      title: "Quel est votre poids ?",
                      child: _buildSlider(weight, 40, 160, "kg", (val) => setState(() => weight = double.parse(val.toStringAsFixed(1)))),
                    ),
                    _buildStep(
                      title: "Quelle est votre taille ?",
                      child: _buildSlider(height, 120, 220, "cm", (val) => setState(() => height = val.roundToDouble())),
                    ),
                    _buildStep(
                      title: "Votre objectif musculaire ?",
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: ['Full body', 'Pectoraux', 'Dos', 'Jambes'].map((m) => _buildGridTile(m, targetMuscle, (val) => setState(() => targetMuscle = val))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF66),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _nextStep,
                  child: Text(
                    _currentStep == 4 ? "GÉNÉRER MON PROFIL" : "SUIVANT",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 30),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    );
  }

  Widget _buildSelectionTile(String value, String groupValue, ValueChanged<String> onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1A00FF66) : const Color(0xFF121824),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_off, color: isSelected ? const Color(0xFF00FF66) : Colors.white30),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(String value, String groupValue, ValueChanged<String> onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1A00FF66) : const Color(0xFF121824),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white10),
        ),
        child: Text(value, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF00FF66) : Colors.white)),
      ),
    );
  }

  Widget _buildSlider(double value, double min, double max, String unit, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value.toString(), style: const TextStyle(fontSize: 54, fontWeight: FontWeight.bold, color: Color(0xFF00FF66))),
            const SizedBox(width: 8),
            Text(unit, style: const TextStyle(fontSize: 20, color: Colors.white54)),
          ],
        ),
        const SizedBox(height: 30),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: const Color(0xFF00FF66),
          inactiveColor: Colors.white12,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// --- INTERFACE PRINCIPALE ---
class VipFitHome extends StatefulWidget {
  const VipFitHome({super.key});

  @override
  State<VipFitHome> createState() => _VipFitHomeState();
}

class _VipFitHomeState extends State<VipFitHome> {
  int _currentIndex = 0;
  double waterDrunk = 0.0;
  int sportDuration = 0;
  int sleepHours = 7;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        onAssessmentCompleted: (water, duration, sleep) {
          setState(() {
            waterDrunk = water;
            sportDuration = duration;
            sleepHours = sleep;
          });
        },
      ),
      WeeklyProgramPage(water: waterDrunk, sportDuration: sportDuration, sleep: sleepHours),
      const PlaceholderPage(title: "Séances", icon: Icons.fitness_center),
      const PlaceholderPage(title: "Profil", icon: Icons.person),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF080B10),
        selectedItemColor: const Color(0xFF00FF66),
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.flash_on), label: 'Activités'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week), label: 'Programme'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Séances'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

/// --- TABLEAU DE BORD ---
class DashboardPage extends StatelessWidget {
  final Function(double, int, int) onAssessmentCompleted;

  const DashboardPage({super.key, required this.onAssessmentCompleted});

  @override
  Widget build(BuildContext context) {
    final double weight = LocalStorage.get('weight') ?? 70.0;
    final double height = LocalStorage.get('height') ?? 175.0;
    final double bmi = weight / ((height / 100) * (height / 100));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("VIPFIT", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF00FF66), letterSpacing: 2)),
            const SizedBox(height: 20),
            const Text("Bonjour Boss, prêt ?", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF121824),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VOTRE IMC ACTUEL", style: TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 6),
                      Text(bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(bmi > 25 ? "Surpoids" : bmi < 18.5 ? "Maigreur" : "Normal", style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () => _showAssessmentModal(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF66)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Calculer ma journée", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Icon(Icons.chevron_right, color: Color(0xFF00FF66)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showAssessmentModal(BuildContext context) {
    double tempWater = 1.5;
    int tempDuration = 45;
    int tempSleep = 7;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0E131F),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(top: 24, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Bilan du Jour", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildModalSlider("Eau : ${tempWater.toStringAsFixed(1)} L", tempWater, 0, 5, (v) => setModalState(() => tempWater = v)),
                  _buildModalSlider("Sport : $tempDuration min", tempDuration.toDouble(), 0, 180, (v) => setModalState(() => tempDuration = v.toInt())),
                  _buildModalSlider("Sommeil : $tempSleep h", tempSleep.toDouble(), 3, 12, (v) => setModalState(() => tempSleep = v.toInt())),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black),
                      onPressed: () {
                        onAssessmentCompleted(tempWater, tempDuration, tempSleep);
                        Navigator.pop(context);
                      },
                      child: const Text("METTRE À JOUR"),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalSlider(String title, double current, double min, double max, ValueChanged<double> onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Slider(value: current, min: min, max: max, activeColor: const Color(0xFF00FF66), onChanged: onChange),
      ],
    );
  }
}

/// --- PROGRAMME DE LA SEMAINE ---
class WeeklyProgramPage extends StatelessWidget {
  final double water;
  final int sportDuration;
  final int sleep;

  const WeeklyProgramPage({super.key, required this.water, required this.sportDuration, required this.sleep});

  @override
  Widget build(BuildContext context) {
    final double weight = LocalStorage.get('weight') ?? 70.0;
    final double height = LocalStorage.get('height') ?? 175.0;
    final double bmi = weight / ((height / 100) * (height / 100));

    double targetWater = bmi > 25.0 ? 3.0 : 2.2;
    int targetSleep = bmi < 18.5 ? 9 : 8;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Votre programme", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _card(Icons.water_drop, "Hydratation", "Objectif : $targetWater L/jour", water >= targetWater),
                  const SizedBox(height: 12),
                  _card(Icons.bed, "Sommeil", "Objectif : $targetSleep h/nuit", sleep >= targetSleep),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, String subtitle, bool isOk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF121824), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: isOk ? const Color(0xFF00FF66) : Colors.orange),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.white54)),
            ],
          )
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;
  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, size: 40, color: Colors.white24), Text(title)]));
  }
}
