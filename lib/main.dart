import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const VipFitApp());
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
        scaffoldBackgroundColor: const Color(0xFF06090E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF66), 
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF0F1522),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingWizard(),
    );
  }
}

/// --- MODULE ONBOARDING PREMIUM ---
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

  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: age.toString());
    _weightController = TextEditingController(text: weight.toString());
    _heightController = TextEditingController(text: height.toInt().toString());
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => VipFitHome(
            sex: sex,
            age: age,
            weight: weight,
            height: height,
            targetMuscle: targetMuscle,
          ),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
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
              Row(
                children: List.generate(5, (index) => Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: index <= _currentStep ? const Color(0xFF00FF66) : Colors.white.withOpacity(0.05),
                      boxShadow: index == _currentStep ? [
                        BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.5), blurRadius: 8, spreadRadius: 1)
                      ] : null,
                      borderRadius: BorderRadius.circular(10),
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
                      title: "Déterminons votre profil",
                      subtitle: "Le genre influence les calculs de métabolisme de base.",
                      child: Column(
                        children: ['Homme', 'Femme', 'Autre'].map((s) => _buildSelectionTile(s, sex, (val) => setState(() => sex = val))).toList(),
                      ),
                    ),
                    _buildStep(
                      title: "Quel âge avez-vous ?",
                      subtitle: "Votre âge permet d'ajuster vos zones de fréquence cardiaque.",
                      child: _buildEditableSlider(
                        controller: _ageController,
                        value: age.toDouble(),
                        min: 14,
                        max: 99,
                        unit: "ans",
                        onChanged: (val) {
                          setState(() {
                            age = val.toInt();
                            if (!_ageController.hasFocus) {
                              _ageController.text = age.toString();
                            }
                          });
                        },
                        onTextChanged: (val) {
                          if (val.isEmpty) return;
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            setState(() {
                              age = parsed.toInt().clamp(14, 99);
                            });
                          }
                        }
                      ),
                    ),
                    _buildStep(
                      title: "Quel est votre poids actuel ?",
                      subtitle: "Soyez honnête, c'est le point de départ de votre mutation.",
                      child: _buildEditableSlider(
                        controller: _weightController,
                        value: weight,
                        min: 40,
                        max: 180,
                        unit: "kg",
                        isDecimal: true,
                        onChanged: (val) {
                          setState(() {
                            weight = double.parse(val.toStringAsFixed(1));
                            if (!_weightController.hasFocus) {
                              _weightController.text = weight.toString();
                            }
                          });
                        },
                        onTextChanged: (val) {
                          if (val.isEmpty) return;
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            setState(() {
                              weight = parsed.clamp(40.0, 180.0);
                            });
                          }
                        }
                      ),
                    ),
                    _buildStep(
                      title: "Quelle est votre taille ?",
                      subtitle: "Indispensable pour calculer précisément votre IMC.",
                      child: _buildEditableSlider(
                        controller: _heightController,
                        value: height,
                        min: 120,
                        max: 230,
                        unit: "cm",
                        onChanged: (val) {
                          setState(() {
                            height = val.roundToDouble();
                            if (!_heightController.hasFocus) {
                              _heightController.text = height.toInt().toString();
                            }
                          });
                        },
                        onTextChanged: (val) {
                          if (val.isEmpty) return;
                          final parsed = double.tryParse(val);
                          if (parsed != null) {
                            setState(() {
                              height = parsed.roundToDouble().clamp(120.0, 230.0);
                            });
                          }
                        }
                      ),
                    ),
                    _buildStep(
                      title: "Cible prioritaire ?",
                      subtitle: "Votre programme d'entraînement sera configuré sur cette zone.",
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.6,
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
                    elevation: 4,
                    shadowColor: const Color(0xFF00FF66).withOpacity(0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _nextStep,
                  child: Text(
                    _currentStep == 4 ? "GÉNÉRER MON COMPTE" : "CONTINUER",
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required String title, required String subtitle, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.white38)),
        const SizedBox(height: 35),
        Expanded(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), child: child)),
      ],
    );
  }

  Widget _buildSelectionTile(String value, String groupValue, ValueChanged<String> onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x0F00FF66) : const Color(0xFF0F1522),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white.withOpacity(0.03), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, color: isSelected ? const Color(0xFF00FF66) : Colors.white)),
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: isSelected ? const Color(0xFF00FF66) : Colors.white24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(String value, String groupValue, ValueChanged<String> onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x0F00FF66) : const Color(0xFF0F1522),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white.withOpacity(0.03), width: 1.5),
        ),
        child: Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500, 
            color: isSelected ? const Color(0xFF00FF66) : Colors.white
          ),
        ),
      ),
    );
  }

  Widget _buildEditableSlider({
    required TextEditingController controller,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
    required ValueChanged<String> onTextChanged,
    bool isDecimal = false,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1522),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Row(
            mainAxisAlignment: Main开启Center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 110, 
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onChanged: onTextChanged,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF00FF66), letterSpacing: -1),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(unit, style: const TextStyle(fontSize: 20, color: Colors.white38, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 35),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: const Color(0xFF00FF66),
            inactiveTrackColor: Colors.white.withOpacity(0.05),
            thumbColor: Colors.white,
            overlayColor: const Color(0xFF00FF66).withOpacity(0.15),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12, pressedThumbRadius: 15),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: (val) {
              onChanged(val);
              if (!controller.hasFocus) {
                controller.text = isDecimal ? val.toStringAsFixed(1) : val.toInt().toString();
              }
            },
          ),
        ),
        const SizedBox(height: 10),
        Text("Appuyez sur le chiffre pour l'éditer au clavier", style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.2))),
      ],
    );
  }
}

/// --- INTERFACE PRINCIPALE ---
class VipFitHome extends StatefulWidget {
  final String sex;
  final int age;
  final double weight;
  final double height;
  final String targetMuscle;

  const VipFitHome({
    super.key,
    required this.sex,
    required this.age,
    required this.weight,
    required this.height,
    required this.targetMuscle,
  });

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
        weight: widget.weight,
        height: widget.height,
        targetMuscle: widget.targetMuscle,
        onAssessmentCompleted: (water, duration, sleep) {
          setState(() {
            waterDrunk = water;
            sportDuration = duration;
            sleepHours = sleep;
          });
        },
      ),
      WeeklyProgramPage(
        weight: widget.weight,
        height: widget.height,
        water: waterDrunk, 
        sportDuration: sportDuration, 
        sleep: sleepHours
      ),
      const WorkoutsPage(),
      ProfilePage(
        age: widget.age,
        weight: widget.weight,
        height: widget.height,
        targetMuscle: widget.targetMuscle,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.02), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF06090E),
          selectedItemColor: const Color(0xFF00FF66),
          unselectedItemColor: Colors.white24,
          fontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.bolt_rounded), label: 'ÉNERGIE'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes_rounded), label: 'CIBLES'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'SEANCES'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'PROFIL'),
          ],
        ),
      ),
    );
  }
}

/// --- TABLEAU DE BORD ---
class DashboardPage extends StatelessWidget {
  final double weight;
  final double height;
  final String targetMuscle;
  final Function(double, int, int) onAssessmentCompleted;

  const DashboardPage({
    super.key, 
    required this.weight,
    required this.height,
    required this.targetMuscle,
    required this.onAssessmentCompleted
  });

  @override
  Widget build(BuildContext context) {
    final double bmi = weight / ((height / 100) * (height / 100));

    String motivationPhrase = "Le succès n'est pas une option, forgeons ce physique.";
    if (targetMuscle == 'Pectoraux') motivationPhrase = "Focus sur la puissance brute du buste aujourd'hui.";
    if (bmi > 25) motivationPhrase = "Cardio haute intensité requis. On brûle tout.";

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("VIPFIT", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF00FF66), letterSpacing: 3)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0x1F00FF66), borderRadius: BorderRadius.circular(20)),
                  child: const Text("PRO MEMBER", style: TextStyle(color: Color(0xFF00FF66), fontSize: 10, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 35),
            const Text("Gagnez votre journée", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            Text(motivationPhrase, style: const TextStyle(fontSize: 14, color: Colors.white38)),
            const SizedBox(height: 30),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1522),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.02)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VOTRE INDICE MASSE CORPORELLE", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      const SizedBox(height: 8),
                      Text(bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: -1)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: bmi > 25 ? Colors.orange.withOpacity(0.1) : const Color(0x0F00FF66),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bmi > 25 ? "Surpoids" : bmi < 18.5 ? "Maigreur" : "Athlétique", 
                      style: TextStyle(color: bmi > 25 ? Colors.orange : const Color(0xFF00FF66), fontWeight: FontWeight.black, fontSize: 13)
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            
            InkWell(
              onTap: () => _showAssessmentModal(context),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF0F1522), Color(0xFF090D15)]),
                  border: Border.all(color: const Color(0xFF00FF66).withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.05), blurRadius: 15)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.add_moderator_rounded, color: Color(0xFF00FF66), size: 28),
                        SizedBox(width: 16),
                        Text("Enregistrer mes data du jour", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF00FF66), size: 16),
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
      backgroundColor: const Color(0xFF0B0E14),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(top: 30, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Mettre à jour mes métriques", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 25),
                  _buildModalSlider("Consommation d'eau", tempWater, 0, 5, "L", (v) => setModalState(() => tempWater = v)),
                  _buildModalSlider("Activité physique", tempDuration.toDouble(), 0, 180, "min", (v) => setModalState(() => tempDuration = v.toInt())),
                  _buildModalSlider("Sommeil récupérateur", tempSleep.toDouble(), 3, 12, "heures", (v) => setModalState(() => tempSleep = v.toInt())),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FF66), 
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        onAssessmentCompleted(tempWater, tempDuration, tempSleep);
                        Navigator.pop(context);
                      },
                      child: const Text("SAUVEGARDER LES DATA", style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
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

  Widget _buildModalSlider(String title, double current, double min, double max, String unit, ValueChanged<double> onChange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white70)),
              Text("${current is int ? current : current.toStringAsFixed(1)} $unit", style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(value: current, min: min, max: max, activeColor: const Color(0xFF00FF66), onChanged: onChange),
        ],
      ),
    );
  }
}

/// --- PROGRAMME DE LA SEMAINE ---
class WeeklyProgramPage extends StatelessWidget {
  final double weight;
  final double height;
  final double water;
  final int sportDuration;
  final int sleep;

  const WeeklyProgramPage({
    super.key, 
    required this.weight,
    required this.height,
    required this.water, 
    required this.sportDuration, 
    required this.sleep
  });

  @override
  Widget build(BuildContext context) {
    final double bmi = weight / ((height / 100) * (height / 100));

    double targetWater = bmi > 25.0 ? 3.5 : 2.5;
    int targetSleep = bmi < 18.5 ? 9 : 8;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vos objectifs de santé", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            const Text("Atteignez vos quotas pour valider le statut élite.", style: TextStyle(fontSize: 14, color: Colors.white38)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                children: [
                  _card(Icons.water_drop_rounded, "Hydratation", "Actuel: ${water.toStringAsFixed(1)}L / Cible: $targetWater L", water >= targetWater),
                  const SizedBox(height: 16),
                  _card(Icons.dark_mode_rounded, "Sommeil", "Actuel: ${sleep}h / Cible: $targetSleep h", sleep >= targetSleep),
                  const SizedBox(height: 16),
                  _card(Icons.fitness_center_rounded, "Workout Quotidien", "Actuel: ${sportDuration}min / Cible: 45 min", sportDuration >= 45),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _card(IconData icon, String title, String subtitle, bool isOk) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1522), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isOk ? const Color(0xFF00FF66).withOpacity(0.2) : Colors.white.withOpacity(0.02)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isOk ? const Color(0x1F00FF66) : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14)
            ),
            child: Icon(icon, color: isOk ? const Color(0xFF00FF66) : Colors.orange, size: 24),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }
}

/// --- VRAIE VIEW: SÉANCES D'ENTRAÎNEMENT ---
class WorkoutsPage extends StatelessWidget {
  const WorkoutsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Programmes d'élite", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 4),
            const Text("Sélectionnez votre routine d'assaut.", style: TextStyle(fontSize: 14, color: Colors.white38)),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _workoutTile("Destruction Pectorale", "Intensité Maximale • 50 min", "Lourds développés couchés & écartés", "HARDCORE"),
                  _workoutTile("Conditioning Full Body", "Brûleur de graisse • 35 min", "HIIT intense sans matériel", "CARDIO"),
                  _workoutTile("Dos de Titan", "Volume Supérieur • 45 min", "Tractions lestées & rowing", "STRENGTH"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _workoutTile(String title, String details, String desc, String tag) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1522),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF00E5FF))),
              ),
              const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF00FF66), size: 32),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(details, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}

/// --- VRAIE VIEW: PROFIL UTILISATEUR & MODIFICATION ---
class ProfilePage extends StatelessWidget {
  final int age;
  final double weight;
  final double height;
  final String targetMuscle;

  const ProfilePage({
    super.key,
    required this.age,
    required this.weight,
    required this.height,
    required this.targetMuscle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Votre Centre de Commande", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(colors: [Color(0xFF00FF66), Color(0xFF00E5FF)]),
                      boxShadow: [BoxShadow(color: const Color(0xFF00FF66).withOpacity(0.2), blurRadius: 20)],
                    ),
                    child: const Icon(Icons.person_rounded, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  const Text("BOSS VIPFIT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const Text("Statut: Déterminé", style: TextStyle(color: Color(0xFF00FF66), fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _profileRow("Objectif actuel", targetMuscle),
            _profileRow("Poids enregistré", "$weight kg"),
            _profileRow("Taille", "${height.toInt()} cm"),
            _profileRow("Âge", "$age ans"),
          ],
        ),
      ),
    );
  }

  Widget _profileRow(String label, String val) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1522),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.w500)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
