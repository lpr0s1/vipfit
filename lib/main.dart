import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF050510),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFD700),
          brightness: Brightness.dark,
          primary: const Color(0xFFFFD700),
          secondary: const Color(0xFF00D4FF),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
          ),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  int? age;
  String? sex;
  double? weight;
  double? height;
  String? targetMuscle;

  final List<String> sexes = ['Homme', 'Femme', 'Autre'];
  final List<String> muscles = [
    'Full body',
    'Pectoraux',
    'Dos',
    'Épaules',
    'Bras',
    'Abdos',
    'Jambes',
    'Fessiers',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF050510), Color(0xFF101020)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _VipFitLogo(),
              const SizedBox(height: 24),
              Text(
                'Bienvenue dans VipFit',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Crée ton profil pour générer un programme de boss.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildForm(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _VipCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profil', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                _VipTextField(
                  label: 'Âge',
                  hint: 'Ex: 25',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entre ton âge';
                    }
                    final parsed = int.tryParse(value);
                    if (parsed == null || parsed < 10 || parsed > 100) {
                      return 'Âge invalide';
                    }
                    return null;
                  },
                  onSaved: (value) => age = int.tryParse(value ?? ''),
                ),
                const SizedBox(height: 12),
                _VipDropdown<String>(
                  label: 'Sexe',
                  value: sex,
                  items: sexes,
                  itemLabel: (v) => v,
                  validator: (value) =>
                      value == null ? 'Sélectionne ton sexe' : null,
                  onChanged: (value) => setState(() => sex = value),
                ),
                const SizedBox(height: 12),
                _VipTextField(
                  label: 'Poids (kg)',
                  hint: 'Ex: 75',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entre ton poids';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 30 || parsed > 250) {
                      return 'Poids invalide';
                    }
                    return null;
                  },
                  onSaved: (value) => weight = double.tryParse(value ?? ''),
                ),
                const SizedBox(height: 12),
                _VipTextField(
                  label: 'Taille (cm)',
                  hint: 'Ex: 180',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entre ta taille';
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed < 130 || parsed > 230) {
                      return 'Taille invalide';
                    }
                    return null;
                  },
                  onSaved: (value) => height = double.tryParse(value ?? ''),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _VipCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Objectif', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                _VipDropdown<String>(
                  label: 'Muscle à prioriser',
                  value: targetMuscle,
                  items: muscles,
                  itemLabel: (v) => v,
                  validator: (value) =>
                      value == null ? 'Choisis un groupe musculaire' : null,
                  onChanged: (value) => setState(() => targetMuscle = value),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _onContinue,
              child: const Text(
                'Entrer dans VipFit',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VipFitHome(
            age: age!,
            sex: sex!,
            weight: weight!,
            height: height!,
            targetMuscle: targetMuscle!,
          ),
        ),
      );
    }
  }
}

class VipFitHome extends StatefulWidget {
  final int age;
  final String sex;
  final double weight;
  final double height;
  final String targetMuscle;

  const VipFitHome({
    super.key,
    required this.age,
    required this.sex,
    required this.weight,
    required this.height,
    required this.targetMuscle,
  });

  @override
  State<VipFitHome> createState() => _VipFitHomeState();
}

class _VipFitHomeState extends State<VipFitHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DashboardPage(
        age: widget.age,
        sex: widget.sex,
        weight: widget.weight,
        height: widget.height,
        targetMuscle: widget.targetMuscle,
      ),
      _TrainingPage(targetMuscle: widget.targetMuscle),
      _NutritionPage(
        age: widget.age,
        sex: widget.sex,
        weight: widget.weight,
      ),
      _ProfilePage(
        age: widget.age,
        sex: widget.sex,
        weight: widget.weight,
        height: widget.height,
        targetMuscle: widget.targetMuscle,
      ),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_currentIndex]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF050510),
          border: Border(
            top: BorderSide(color: Colors.white12, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFFFD700),
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.star_border_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_rounded),
              label: 'Training',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_rounded),
              label: 'Nutrition',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardPage extends StatelessWidget {
  final int age;
  final String sex;
  final double weight;
  final double height;
  final String targetMuscle;

  const _DashboardPage({
    required this.age,
    required this.sex,
    required this.weight,
    required this.height,
    required this.targetMuscle,
  });

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiLabel {
    if (bmi < 18.5) return 'Maigre';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Surpoids';
    return 'Obésité';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050510), Color(0xFF151530)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _VipFitLogo(),
          const SizedBox(height: 16),
          Text(
            'Ton tableau de bord',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Mode VIP activé. Continue à construire ton physique de boss.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _VipCard(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IMC',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bmiLabel,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VipCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Objectif',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        targetMuscle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Programme personnalisé généré pour toi.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _VipCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Focus du jour',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Aujourd\'hui, on met l\'accent sur $targetMuscle. '
                  'Reste régulier, c\'est comme ça qu\'on passe en mode VIP.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: const [
                    _TagChip(label: 'Discipline'),
                    SizedBox(width: 8),
                    _TagChip(label: 'Progression'),
                    SizedBox(width: 8),
                    _TagChip(label: 'Confiance'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainingPage extends StatelessWidget {
  final String targetMuscle;

  const _TrainingPage({required this.targetMuscle});

  List<Map<String, String>> get baseWorkouts => [
        {
          'title': 'Échauffement global',
          'duration': '8-10 min',
          'details':
              'Cordes à sauter, jumping jacks, mobilisation articulaire pour préparer le corps.'
        },
        {
          'title': 'Finisher cardio',
          'duration': '5-8 min',
          'details':
              'Burpees, mountain climbers, sprint sur place pour finir fort.'
        },
      ];

  List<Map<String, String>> getTargetWorkouts(String muscle) {
    switch (muscle) {
      case 'Pectoraux':
        return [
          {
            'title': 'Développé couché (ou pompes)',
            'duration': '4 x 8-12 reps',
            'details':
                'Contrôle la descente, pousse explosif. 60-90s de repos entre les séries.'
          },
          {
            'title': 'Pompes inclinées',
            'duration': '3 x 12-15 reps',
            'details':
                'Mets les pieds surélevés pour charger le haut des pectoraux.'
          },
        ];
      case 'Dos':
        return [
          {
            'title': 'Tractions (ou tirage horizontal)',
            'duration': '4 x 6-10 reps',
            'details':
                'Concentre-toi sur la contraction du dos, pas seulement les bras.'
          },
          {
            'title': 'Rowing buste penché',
            'duration': '3 x 10-12 reps',
            'details':
                'Garde le dos droit, tire les coudes vers l’arrière, contrôle le retour.'
          },
        ];
      case 'Épaules':
        return [
          {
            'title': 'Développé militaire',
            'duration': '4 x 8-10 reps',
            'details':
                'Assis ou debout, gainage serré, trajectoire contrôlée au-dessus de la tête.'
          },
          {
            'title': 'Élévations latérales',
            'duration': '3 x 12-15 reps',
            'details':
                'Léger mais propre, monte jusqu’à l’horizontale, pas plus haut.'
          },
        ];
      case 'Bras':
        return [
          {
            'title': 'Curl biceps',
            'duration': '4 x 10-12 reps',
            'details':
                'Pas d’élan, concentre-toi sur la contraction du biceps en haut.'
          },
          {
            'title': 'Extensions triceps',
            'duration': '3 x 10-12 reps',
            'details':
                'Coudes fixes, étire bien en bas, verrouille en haut sans forcer les articulations.'
          },
        ];
      case 'Abdos':
        return [
          {
            'title': 'Gainage',
            'duration': '3 x 30-45 sec',
            'details':
                'Corps aligné, ne laisse pas le bassin tomber, respire calmement.'
          },
          {
            'title': 'Crunchs contrôlés',
            'duration': '3 x 15-20 reps',
            'details':
                'Monte en enroulant la colonne, pas en tirant sur la nuque.'
          },
        ];
      case 'Jambes':
        return [
          {
            'title': 'Squats',
            'duration': '4 x 8-12 reps',
            'details':
                'Pieds largeur épaules, descends contrôlé, pousse fort dans le sol.'
          },
          {
            'title': 'Fentes avant',
            'duration': '3 x 10-12 reps / jambe',
            'details':
                'Grand pas, genou arrière proche du sol, buste droit, contrôle.'
          },
        ];
      case 'Fessiers':
        return [
          {
            'title': 'Hip thrust',
            'duration': '4 x 10-12 reps',
            'details':
                'Pousse avec les talons, serre les fessiers en haut, ne creuse pas le bas du dos.'
          },
          {
            'title': 'Soulevé de terre jambes tendues',
            'duration': '3 x 10-12 reps',
            'details':
                'Légère flexion des genoux, ressens l’étirement à l’arrière des jambes.'
          },
        ];
      default:
        return [
          {
            'title': 'Full body basique',
            'duration': '3-4 exercices',
            'details':
                'Squats, pompes, rowing, gainage. 3 tours, 60-90s de repos.'
          },
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final workouts = [...getTargetWorkouts(targetMuscle), ...baseWorkouts];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050510), Color(0xFF101020)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Training', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text(
            'Séance orientée $targetMuscle. Garde l’intensité, pas la précipitation.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: workouts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final w = workouts[index];
                return _VipCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w['title']!,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        w['duration']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        w['details']!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionPage extends StatelessWidget {
  final int age;
  final String sex;
  final double weight;

  const _NutritionPage({
    required this.age,
    required this.sex,
    required this.weight,
  });

  String get calorieHint {
    // estimation très simple, juste pour donner un ordre d’idée
    final base = weight * 30;
    return '${base.toStringAsFixed(0)} - ${(base + 300).toStringAsFixed(0)} kcal / jour';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050510), Color(0xFF101020)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nutrition', style: theme.textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(
              'Base pour prendre du muscle proprement. Ajuste selon ton ressenti.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            _VipCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repère calorique',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Âge: $age ans • Sexe: $sex • Poids: ${weight.toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Objectif global (approximation) : $calorieHint',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Priorise des aliments bruts, peu transformés, et une bonne hydratation.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _MealCard(
              title: 'Matin – Petit-déjeuner',
              subtitle: 'Énergie stable + protéines',
              items: const [
                '• Source de protéines : œufs, fromage blanc, yaourt grec, tofu.',
                '• Glucides complexes : flocons d’avoine, pain complet, fruits.',
                '• Bon gras : amandes, noix, beurre de cacahuète 100%.',
                '• Boisson : eau, thé, café sans excès de sucre.',
              ],
              tip:
                  'Évite les gros pics de sucre (pâtisseries, céréales ultra sucrées) pour ne pas t’endormir après.',
            ),
            const SizedBox(height: 12),
            _MealCard(
              title: 'Midi – Déjeuner',
              subtitle: 'Performance + récupération',
              items: const [
                '• Protéines : poulet, dinde, poisson, œufs, légumineuses.',
                '• Glucides : riz complet, pâtes complètes, quinoa, patate douce.',
                '• Légumes : au moins la moitié de l’assiette.',
                '• Lipides : huile d’olive, avocat, oléagineux.',
              ],
              tip:
                  'Garde un repas équilibré, pas trop lourd, pour pouvoir t’entraîner sans te sentir écrasé.',
            ),
            const SizedBox(height: 12),
            _MealCard(
              title: 'Soir – Dîner',
              subtitle: 'Récupération + sommeil',
              items: const [
                '• Protéines : poisson, œufs, viande maigre, tofu, légumineuses.',
                '• Glucides modérés : riz, patate douce, légumes racines.',
                '• Beaucoup de légumes : fibres + micronutriments.',
                '• Évite les gros plats ultra gras/sucrés juste avant de dormir.',
              ],
              tip:
                  'Mange suffisamment pour récupérer, mais pas au point d’être lourd au coucher.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final int age;
  final String sex;
  final double weight;
  final double height;
  final String targetMuscle;

  const _ProfilePage({
    required this.age,
    required this.sex,
    required this.weight,
    required this.height,
    required this.targetMuscle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF050510), Color(0xFF101020)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profil', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text(
            'Tes infos de base pour personnaliser VipFit.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          _VipCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Données personnelles',
                    style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                _ProfileRow(label: 'Âge', value: '$age ans'),
                _ProfileRow(label: 'Sexe', value: sex),
                _ProfileRow(
                    label: 'Poids', value: '${weight.toStringAsFixed(1)} kg'),
                _ProfileRow(
                    label: 'Taille', value: '${height.toStringAsFixed(1)} cm'),
                _ProfileRow(label: 'Muscle ciblé', value: targetMuscle),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _VipCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mindset VIP', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                const Text(
                  '• Règle n°1 : régularité > perfection.\n'
                  '• Règle n°2 : dors, mange, bouge comme quelqu’un qui respecte son corps.\n'
                  '• Règle n°3 : chaque séance est un vote pour la version de toi que tu veux devenir.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widgets "premium"

class _VipFitLogo extends StatelessWidget {
  const _VipFitLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(
          Icons.workspace_premium_rounded,
          color: Color(0xFFFFD700),
          size: 32,
        ),
        SizedBox(width: 8),
        Text(
          'VipFit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _VipCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const _VipCard({required this.child, this.gradient});

  @override
  Widget build(BuildContext context) {
    final baseGradient = gradient ??
        const LinearGradient(
          colors: [Color(0xFF151530), Color(0xFF050510)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: baseGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _VipTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const _VipTextField({
    required this.label,
    required this.hint,
    required this.keyboardType,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            )),
        const SizedBox(height: 4),
        TextFormField(
          style: const TextStyle(color: Colors.white),
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: const Color(0xFF101020),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.white24),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFFFD700), width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _VipDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;

  const _VipDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      validator: validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 4),
            InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF101020),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: state.hasError ? Colors.red : Colors.white24,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: value,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF101020),
                  iconEnabledColor: Colors.white70,
                  items: items
                      .map(
                        (e) => DropdownMenuItem<T>(
                          value: e,
                          child: Text(itemLabel(e)),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    onChanged?.call(val);
                    state.didChange(val);
                  },
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
        color: const Color(0xFF101020),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white70),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final String tip;

  const _MealCard({
    required this.title,
    required this.subtitle,
    required this.items,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _VipCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                e,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tip : $tip',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
