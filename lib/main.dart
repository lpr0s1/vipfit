import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitLab()))));

class VipFitLab extends StatefulWidget {
  const VipFitLab({super.key});
  @override
  State<VipFitLab> createState() => _VipFitLabState();
}

class _VipFitLabState extends State<VipFitLab> {
  bool showPlan = false;

  // CONFIGURATION DES 20 PARAMÈTRES ATHLÉTIQUES
  final List<String> titles = [
    "01. Âge (ans)", "02. Poids corporel (kg)", "03. Taille (cm)",
    "04. Sommeil (heures/nuit)", "05. Hydratation (L/jour)", "06. Séances muscu / semaine",
    "07. Nombre de repas solides / jour", "08. Années de pratique", "09. Durée de séance (min)",
    "10. Cardio hebdomadaire (min)", "11. Niveau de stress (1 à 10)", "12. Écarts diète / semaine",
    "13. Qualité récupération (1 à 10)", "14. Niveau d'énergie (1 à 10)", "15. Activité quotidienne (pas x1000)",
    "16. Surplus calibré visé (kcal)", "17. Temps de repos (secondes)", "18. Intensité d'effort (1 à 10)",
    "19. Rigueur nutritionnelle (1 à 10)", "20. Focus mental & discipline (1 à 10)"
  ];

  final List<double> mins = [16, 45, 140, 4, 1, 0, 2, 0, 30, 0, 1, 0, 1, 1, 2, 150, 30, 1, 1, 1];
  final List<double> maxs = [60, 130, 210, 10, 6, 7, 7, 15, 120, 240, 10, 10, 10, 10, 20, 800, 180, 10, 10, 10];
  late List<double> values;
  String sexe = "Homme";

  @override
  void initState() {
    super.initState();
    values = [25, 75, 175, 7, 2, 4, 4, 2, 60, 45, 4, 2, 7, 7, 8, 400, 90, 8, 7, 8];
  }

  // ALGORITHME DE CALCUL MÉTABOLIQUE COMPLET
  int get targetCalories {
    double bmr = (10 * values[1]) + (6.25 * values[2]) - (5 * values[0]) + (sexe == "Homme" ? 5 : -161);
    double multiplicateurActivite = 1.2 + (values[5] * 0.1) + (values[14] * 0.01);
    return (bmr * multiplicateurActivite).toInt() + values[15].toInt();
  }

  int get targetProteins => (values[1] * 2.2).toInt();

  @override
  Widget build(BuildContext context) {
    const Color steelGrey = Color(0xFF8E8E93);
    
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        const Text("VIP FIT LAB", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const Text("ANALYSE BIOMÉTRIQUE & PROTOCOLE DE MASSE ATHLÉTIQUE", style: TextStyle(color: steelGrey, fontSize: 9, letterSpacing: 1)),
        const Divider(color: Colors.white10, height: 40),

        if (!showPlan) ...[
          // Choix du Sexe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Sélection du Sexe :", style: TextStyle(color: Colors.white90, fontSize: 13)),
              DropdownButton<String>(
                value: sexe, dropdownColor: Colors.black, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                underline: Container(),
                items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => sexe = v!),
              )
            ],
          ),
          const Divider(color: Colors.white10, height: 24),

          // Génération des 20 Sliders
          for (int i = 0; i < 20; i++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(titles[i], style: const TextStyle(color: Colors.white90, fontSize: 13)),
                Text(
                  titles[i].contains("L") || titles[i].contains("pas") ? values[i].toStringAsFixed(1) : values[i].toInt().toString(), 
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            Slider(
              value: values[i], min: mins[i], max: maxs[i],
              activeColor: Colors.white, inactiveColor: Colors.white10,
              onChanged: (v) => setState(() => values[i] = v),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 52), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = true),
            child: const Text("GÉNÉRER LE PLAN HIGH-DENSITY", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ] else ...[
          // VUE COMPACTE MONOCHROME POUR SCREENSHOT
          const Text("MÉTRIQUES NUTRITIONNELLES DE SURPLUS", style: TextStyle(color: steelGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 12),
          _row("Objectif Énergétique Journalier", "$targetCalories kcal"),
          _row("Objectif Protéines (Anabolisme)", "${targetProteins}g"),
          _row("Hydratation Requise Minimale", "${values[4] < 3.0 ? 'Ajuster à 3.5' : values[4].toStringAsFixed(1)} L"),
          
          const Divider(color: Colors.white10, height: 40),
          
          const Text("PROGRAMME D'ISOLATION ET D'HYPERTROPHIE", style: TextStyle(color: steelGrey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 16),
          _exo("Bras, Avant-bras & Poignets (Membres Supérieurs)", "• Biceps/Triceps : Curl incliné haltères & Dips lestés (4x10, RPE 9)\n• Avant-bras : Curl inversé à la poulie basse ou barre EZ (3x12)\n• Poignets : Extensions et flexions haltères assis sur banc (3x15, focus contraction)\n• Force de poigne : Extensions statiques suspendues ou Farmer Walk (3 séries max)"),
          _exo("Cuisses & Mollets (Membres Inférieurs)", "• Cuisses : Squat lourd complet barre (4x6) + Leg Press incliné (3x12)\n• Mollets : Extensions debout sur bloc (5x20, avec pause de 2s en étirement bas)\n• Ischios : Soulevé de terre roumain haltères (4x8, contrôle excentrique)"),
          _exo("Ceinture Scapulaire & Postérieure", "• Dos / Dorsaux : Tractions strictes pronation (4xMax) + Rowing barre buste penché (4x8)\n• Épaules : Développé militaire haltères (4x8) + Oiseau sur banc incliné (4x15)"),
          
          const Divider(color: Colors.white10, height: 30),
          
          if (values[3] < 8 || values[10] > 6) ...[
            const Text("FACTEURS DE LIMITATION HORMONALE DETECTÉS", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            const Text("• Sommeil insuffisant ou stress élevé. Hausse du cortisol détectée. Prioriser 8h de sommeil et maximiser la régularité des repas pour protéger le tissu musculaire.", style: TextStyle(color: steelGrey, fontSize: 11, height: 1.4)),
            const SizedBox(height: 24),
          ],
          
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: Colors.white30), minimumSize: const Size(double.infinity, 45), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = false),
            child: const Text("RÉINITIALISER LES DONNÉES", style: TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1)),
          ),
        ]
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _exo(String zone, String exercises) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(zone, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(exercises, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11, height: 1.5)),
        ],
      ),
    );
  }
}
