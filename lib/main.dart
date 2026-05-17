import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const VipFitApp());
}

/// --- PERSISTENCE UNITAIRE RECREÉE SANS DÉPENDANCE ---
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
          primary: Color(0xFF00FF66), // Vert Fluo Néon
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF121824),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.black, letterSpacing: -0.5),
          headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white90, height: 1.5),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingWizard(),
    );
  }
}

/// --- WIDGET EFFECT : TEXTE LETTRE PAR LETTRE ---
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 40),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  String _displayedText = "";
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(widget.duration, (timer) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }
      if (_currentIndex < widget.text.length) {
        setState(() {
          _displayedText += widget.text[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedText, style: widget.style);
  }
}

/// --- WIDGET EFFECT : TEXTE EN DÉGRADÉ ---
class PremiumGradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const PremiumGradientText({
    super.key,
    required this.text,
    this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style?.copyWith(color: Colors.white),
      ),
    );
  }
}

/// --- MODULE ONBOARDING : PAS À PAS ---
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      LocalStorage.save('age', age);
      LocalStorage.save('sex', sex);
      LocalStorage.save('weight', weight);
      LocalStorage.save('height', height);
      LocalStorage.save('targetMuscle', targetMuscle);

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const VipFitHome(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
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
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF66),
                    foregroundColor: Colors.black,
                    elevation: 8,
                    shadowColor: const Color(0x6600FF66),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _nextStep,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    _currentStep == 4 ? "GÉNÉRER MON PROFIL" : "SUIVANT",
                    style: const TextStyle(fontWeight: FontWeight.black, letterSpacing: 0.5),
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
        PremiumGradientText(
          text: title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.black),
          gradient: const LinearGradient(colors: [Colors.white, Colors.white70]),
        ),
        const SizedBox(height: 40),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    );
  }

  Widget _buildSelectionTile(String value, String groupValue, ValueChanged<String> onChanged) {
    final bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1A00FF66) : const Color(0xFF121824),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white10, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: isSelected ? const Color(0xFF00FF66) : Colors.white30),
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
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1A00FF66) : const Color(0xFF121824),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.white10, width: 1.5),
        ),
        child: Text(value, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF00FF66) : Colors.white)),
      ),
    );
  }

  Widget _buildSlider(double value, double min, double max, String unit, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value.toString(), style: const TextStyle(fontSize: 64, fontWeight: FontWeight.black, color: Color(0xFF00FF66))),
              const SizedBox(width: 8),
              Text(unit, style: const TextStyle(fontSize: 20, color: Colors.white54)),
            ],
          ),
        ),
        const SizedBox(height: 40),
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
  String sportDone = "Aucun";
  int sportDuration = 0;
  int sleepHours = 7;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(
        onAssessmentCompleted: (water, sport, duration, sleep) {
          setState(() {
            waterDrunk = water;
            sportDone = sport;
            sportDuration = duration;
            sleepHours = sleep;
          });
        },
      ),
      WeeklyProgramPage(water: waterDrunk, sport: sportDone, sportDuration: sportDuration, sleep: sleepHours),
      const PlaceholderPage(title: "Entraînements", icon: Icons.fitness_center_rounded),
      const PlaceholderPage(title: "Profil & Objectifs", icon: Icons.person_rounded),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: const Color(0xFF080B10),
          selectedItemColor: const Color(0xFF00FF66),
          unselectedItemColor: Colors.white38,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.flash_on_rounded), label: 'Activités'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_view_week_rounded), label: 'Programme'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Séances'),
            BottomNavigationBarItem(icon: Icon(Icons.face_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

/// --- VUE INDEX : TABLEAU DE BORD ---
class DashboardPage extends StatelessWidget {
  final Function(double, String, int, int) onAssessmentCompleted;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PremiumGradientText(
                  text: "VIPFIT",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.black, letterSpacing: 2),
                  gradient: LinearGradient(colors: [Color(0xFF00FF66), Color(0xFF00E5FF)]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0x2200FF66), borderRadius: BorderRadius.circular(20)),
                  child: const Text("STATUT: VIP", style: TextStyle(color: Color(0xFF00FF66), fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 24),
            const TypewriterText(
              text: "Bonjour Boss, prêt à performer ?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF121824), Color(0xFF1A2333)]),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("VOTRE IMC ACTUEL", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(bmi.toStringAsFixed(1), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.black)),
                    ],
                  ),
                  _buildBmiBadge(bmi),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("ÉVALUATION DU JOUR", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white60)),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showAssessmentModal(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF00FF66), width: 1.5),
                  color: const Color(0x0500FF66),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF00FF66), borderRadius: BorderRadius.circular(14)),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Calculer ma journée", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Eau, sommeil, sport & métabolisme", style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded, color: Color(0xFF00FF66)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBmiBadge(double bmi) {
    String label = "Normal";
    Color color = const Color(0xFF00FF66);
    if (bmi < 18.5) { label = "Maigreur"; color = Colors.orange; }
    else if (bmi >= 25 && bmi < 30) { label = "Surpoids"; color = Colors.orangeAccent; }
    else if (bmi >= 30) { label = "Obésité"; color = Colors.redAccent; }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24, left: 24, right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Bilan du Jour", style: TextStyle(fontSize: 24, fontWeight: FontWeight.black)),
                  const SizedBox(height: 20),
                  _buildModalSlider("Eau bue : ${tempWater.toStringAsFixed(1)} L", tempWater, 0, 5, (v) => setModalState(() => tempWater = v)),
                  _buildModalSlider("Durée du sport : $tempDuration min", tempDuration.toDouble(), 0, 180, (v) => setModalState(() => tempDuration = v.toInt())),
                  _buildModalSlider("Heures de sommeil : $tempSleep h", tempSleep.toDouble(), 3, 12, (v) => setModalState(() => tempSleep = v.toInt())),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black),
                      onPressed: () {
                        onAssessmentCompleted(tempWater, "Musculation", tempDuration, tempSleep);
                        Navigator.pop(context);
                      },
                      child: const Text("ANALYSER ET METTRE À JOUR", style: TextStyle(fontWeight: FontWeight.bold)),
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Slider(value: current, min: min, max: max, activeColor: const Color(0xFF00FF66), onChanged: onChange),
      ],
    );
  }
}

/// --- VUE : PROGRAMME DE LA SEMAINE ---
class WeeklyProgramPage extends StatelessWidget {
  final double water;
  final String sport;
  final int sportDuration;
  final int sleep;

  const WeeklyProgramPage({
    super.key,
    required this.water,
    required this.sport,
    required this.sportDuration,
    required this.sleep,
  });

  @override
  Widget build(BuildContext context) {
    final double weight = LocalStorage.get('weight') ?? 70.0;
    final double height = LocalStorage.get('height') ?? 175.0;
    final double bmi = weight / ((height / 100) * (height / 100));

    double targetWater = bmi > 25.0 ? 3.0 : 2.2;
    int targetSleep = bmi < 18.5 ? 9 : 8;

    bool waterOk = water >= targetWater;
    bool sleepOk = sleep >= targetSleep;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PremiumGradientText(
              text: "Votre programme de la semaine",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.black),
              gradient: LinearGradient(colors: [Colors.white, Colors.white70]),
            ),
            const SizedBox(height: 8),
            const Text("Généré algorithmiquement d'après votre métabolisme.", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildRecommendationCard(
                    icon: Icons.water_drop_rounded,
                    title: "Hydratation Hebdomadaire",
                    value: "Objectif : $targetWater Litres / jour",
                    status: waterOk ? "Félicitations, quota atteint !" : "Insuffisant aujourd'hui (Manque ${(targetWater - water).toStringAsFixed(1)}L)",
                    isOk: waterOk,
                  ),
                  const SizedBox(height: 16),
                  _buildRecommendationCard(
                    icon: Icons.king_bed_rounded,
                    title: "Sommeil & Récupération",
                    value: "Objectif : $targetSleep Heures / nuit",
                    status: sleepOk ? "Sommeil réparateur optimal." : "Attention, manque de sommeil détecté.",
                    isOk: sleepOk,
                  ),
                  const SizedBox(height: 16),
                  _buildProgramDetailsCard(bmi),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard({required IconData icon, required String title, required String value, required String status, required bool isOk}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF121824), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isOk ? const Color(0xFF00FF66) : Colors.orangeAccent, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(status, style: TextStyle(color: isOk ? const Color(0xFF00FF66) : Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProgramDetailsCard(double bmi) {
    String focusText = "Équilibre & Renforcement standard.";
    if (bmi < 18.5) {
      focusText = "Focus Hypertrophie : Séances courtes (45 min max), charges lourdes, aucun cardio intensif.";
    } else if (bmi >= 25.0) {
      focusText = "Focus Déficit & Brûle-Graisse : Intégrez 20 min de HIIT à la fin de vos séances de musculation.";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0x1200FF66), Color(0xFF121824)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x3300FF66)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.insights_rounded, color: Color(0xFF00FF66)),
              SizedBox(width: 8),
              Text("Ligne Directrice Nutrition/Sport", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(focusText, style: const TextStyle(color: Colors.white90, height: 1.4)),
        ],
      ),
    );
  }
}

/// --- WIDGET EN ATTENTE DE REMPLISSAGE ---
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 16)),
        ],
      ),
    );
  }
}
