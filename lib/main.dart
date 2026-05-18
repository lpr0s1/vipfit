import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitTabs()))));

class VipFitTabs extends StatefulWidget {
  const VipFitTabs({super.key});
  @override
  State<VipFitTabs> createState() => _VipFitTabsState();
}

class _VipFitTabsState extends State<VipFitTabs> {
  bool showPlan = false;
  int currentTab = 0; // 0: Profil, 1: Hygiène, 2: Training, 3: Mental

  // Les 20 variables stockées proprement dans une liste simple
  final List<double> values = [25, 75, 175, 7, 2, 4, 4, 2, 60, 45, 4, 2, 7, 7, 8, 400, 90, 8, 7, 8];
  String sexe = "Homme";

  // Calculs métaboliques
  int get targetCalories {
    double bmr = (10 * values[1]) + (6.25 * values[2]) - (5 * values[0]) + (sexe == "Homme" ? 5 : -161);
    return (bmr * 1.4).toInt() + values[15].toInt();
  }
  int get targetProteins => (values[1] * 2.2).toInt();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        const Text("VIP FIT LAB", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const Divider(color: Colors.white10, height: 30),

        if (!showPlan) ...[
          // SÉLECTEUR D'ONGLETS ULTRA-LÉGER (Boutons simples côte à côte)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _tabBtn("PROFIL", 0),
              _tabBtn("HYGIÈNE", 1),
              _tabBtn("TRAINING", 2),
              _tabBtn("MENTAL", 3),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),

          // AFFICHAGE STRICT PAR BLOC DE 5 SLIDERS MAXIMUM
          if (currentTab == 0) ...[
            _sexDrop(),
            _slider(0, "Âge (ans)", 16, 60),
            _slider(1, "Poids corporel (kg)", 45, 130),
            _slider(2, "Taille (cm)", 140, 210),
          ],
          if (currentTab == 1) ...[
            _slider(3, "Sommeil (heures/nuit)", 4, 10),
            _slider(4, "Hydratation (L/jour)", 1, 6),
            _slider(6, "Repas solides / jour", 2, 7),
            _slider(11, "Écarts diète / semaine", 0, 10),
            _slider(14, "Niveau d'énergie (1-10)", 1, 10),
          ],
          if (currentTab == 2) ...[
            _slider(5, "Séances muscu / semaine", 0, 7),
            _slider(7, "Années de pratique", 0, 15),
            _slider(8, "Durée de séance (min)", 30, 120),
            _slider(9, "Cardio hebdo (min)", 0, 240),
            _slider(16, "Temps de repos (sec)", 30, 180),
          ],
          if (currentTab == 3) ...[
            _slider(10, "Niveau de stress (1-10)", 1, 10),
            _slider(12, "Qualité récup (1-10)", 1, 10),
            _slider(13, "Activité (pas x1000)", 2, 20),
            _slider(15, "Surplus visé (kcal)", 150, 800),
            _slider(17, "Intensité effort (1-10)", 1, 10),
            _slider(18, "Rigueur diète (1-10)", 1, 10),
            _slider(19, "Focus mental (1-10)", 1, 10),
          ],

          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = true),
            child: const Text("GÉNÉRER LE PLAN ATHLÈTE", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          // VUE PLAN UNIQUE ULTRA COMPACTE ET MONOCHROME
          const Text("MÉTRIQUES NUTRITIONNELLES", style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
          _row("Objectif Journalier", "$targetCalories kcal"),
          _row("Protéines Cibles", "${targetProteins}g"),
          _row("Hydratation Minimum", "${values[4] < 3.0 ? '3.5' : values[4].toStringAsFixed(1)} L"),
          
          const Divider(color: Colors.white10, height: 30),
          const Text("PROTOCOLE D'ENTRAÎNEMENT", style: TextStyle(color: Color(0xFF8E8E93), fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _exo("Bras & Poignets", "• Biceps/Triceps : Curl incliné & Dips (4x10)\n• Avant-bras/Poignets : Curl inversé & Extensions assis (3x15)\n• Grip : Marche du fermier (3 séries max)"),
          _exo("Cuisses & Mollets", "• Cuisses : Squat lourd complet (4x6) + Presse (3x12)\n• Mollets : Extensions debout sur bloc (5x20, contraction 2s)"),
          _exo("Dos & Épaules", "• Dos : Tractions strictes (4xMax) + Rowing barre (4x8)\n• Épaules : Développé militaire (4x8) + Oiseau (4x15)"),
          
          const Divider(color: Colors.white10, height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: Colors.white30), minimumSize: const Size(double.infinity, 45), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = false),
            child: const Text("MODIFIER LES INFOS", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ]
      ],
    );
  }

  // --- COMPOSANTS INTERNES EN LIGNE DROITE POUR XCODE ---
  Widget _tabBtn(String label, int index) {
    bool isSelected = currentTab == index;
    return TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      onPressed: () => setState(() => currentTab = index),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.white30, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
    );
  }

  Widget _sexDrop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Sexe", style: TextStyle(color: Colors.white70, fontSize: 13)),
        DropdownButton<String>(
          value: sexe, dropdownColor: Colors.black, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          underline: Container(),
          items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (v) => setState(() => sexe = v!),
        )
      ],
    );
  }

  Widget _slider(int index, String label, double min, double max) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            Text(values[index].toInt().toString(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: values[index], min: min, max: max,
          activeColor: Colors.white, inactiveColor: Colors.white10,
          onChanged: (v) => setState(() => values[index] = v),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)), Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
    );
  }

  Widget _exo(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)), const SizedBox(height: 2), Text(desc, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11, height: 1.4))]),
    );
  }
}
