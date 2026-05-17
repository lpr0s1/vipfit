import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: VipFitApp(), debugShowCheckedModeBanner: false));

class VipFitApp extends StatefulWidget {
  const VipFitApp({super.key});
  @override
  State<VipFitApp> createState() => _VipFitAppState();
}

class _VipFitAppState extends State<VipFitApp> {
  int step = 0, currentTab = 0, age = 22, pds = 70, tll = 175, calPris = 0, eauPrise = 0;
  String sex = 'Homme', obj = 'Full body';

  // Calculs physiologiques réels (Formule de Mifflin-St Jeor)
  int get calCible {
    double bmr = (10 * pds) + (6.25 * tll) - (5 * age);
    bmr += (sex == 'Homme') ? 5 : -161;
    if (obj == 'Pectoraux' || obj == 'Dos') bmr += 400; // Surplus de masse
    if (pds > 85) bmr -= 200; // Léger déficit si surpoids
    return bmr.toInt();
  }
  int get eauCible => (pds * 35) + (sex == 'Homme' ? 500 : 0);

  // Génération des conseils ultra-personnalisés
  String get nutritionConseil {
    String base = pds > 80 ? "Priorité déficit calorique contrôlé." : "Focus reconstruction musculaire hyperprotéinée.";
    if (age > 40) return "$base Réduisez les glucides rapides, augmentez les bons lipides (Oméga-3) pour préserver le métabolisme.";
    if (sex == 'Femme') return "$base Veillez à un apport optimal en fer et calcium. Ratio : 40% Glucides, 30% Protéines, 30% Lipides.";
    return "$base Maximisez les protéines (2g/kg de poids de corps). Ratio de charge : 50% Glucides complexes, 30% Protéines, 20% Lipides.";
  }

  String get sportConseil {
    if (obj == 'Pectoraux') return "Routine Force : 4 séries de Développé Couché lourd, 3 séries d'Écartés inclinés, 4 séries de Dips. Récupération : 2 min.";
    if (obj == 'Dos') return "Routine Épaisseur : 4 séries de Tractions (lestées si possible), 4 séries de Rowing barre, 3 séries de Soulevé de terre.";
    return "Routine Athlétique : Circuit Full-Body 3x/semaine incluant Squats, Pompes lestées, Burpees et Gainage dynamique pour brûler le gras.";
  }

  String get phraseMotivation {
    if (pds > 85) return "Chaque calorie brûlée est une victoire sur l'ancien toi. Reste focus !";
    if (obj != 'Full body') return "La symétrie parfaite demande une intensité maximale sur la zone $obj. Pousse !";
    return "L'excellence n'est pas un acte, c'est une habitude. Domine ta journée.";
  }

  Widget buildTile(String title, String current, String value, Function(String) onTap) {
    bool isSel = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: isSel ? const Color(0x1F00FF66) : const Color(0xFF0F1522), borderRadius: BorderRadius.circular(16), border: Border.all(color: isSel ? const Color(0xFF00FF66) : Colors.transparent)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(value, style: TextStyle(color: isSel ? const Color(0xFF00FF66) : Colors.white, fontWeight: FontWeight.bold)), Icon(isSel ? Icons.check_circle : Icons.radio_button_off, color: isSel ? const Color(0xFF00FF66) : Colors.white24)]),
      ),
    );
  }

  Widget buildSliderTile(String label, double val, double min, double max, String unit, Function(double) change) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFF0F1522), borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white54)), Text("${val.toInt()} $unit", style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 18))]),
        Slider(value: val, min: min, max: max, activeColor: const Color(0xFF00FF66), inactiveColor: Colors.white10, onChanged: change)
      ]),
    );
  }

  Widget buildDashboardCard(String t, String v, IconData i, Color c, {String sub = ""}) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFF0F1522), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.02))),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(14)), child: Icon(i, color: c, size: 26)),
        const SizedBox(width: 18),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(v, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), if(sub.isNotEmpty) ...[const SizedBox(height: 4), Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 12))]]))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06090E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: step < 5 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("ÉTAPE ${step + 1} / 5", style: const TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 12)),
            const SizedBox(height: 10),
            if (step == 0) ...[const Text("Sélectionnez votre sexe", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black)), const SizedBox(height: 25), ...['Homme', 'Femme'].map((s) => buildTile("Sexe", sex, s, (v) => setState(() => sex = v)))],
            if (step == 1) ...[const Text("Votre âge ?", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black)), const SizedBox(height: 25), buildSliderTile("Âge", age.toDouble(), 16, 80, "ans", (v) => setState(() => age = v.toInt()))],
            if (step == 2) ...[const Text("Votre poids actuel ?", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black)), const SizedBox(height: 25), buildSliderTile("Poids", pds.toDouble(), 40, 150, "kg", (v) => setState(() => pds = v.toInt()))],
            if (step == 3) ...[const Text("Votre taille ?", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black)), const SizedBox(height: 25), buildSliderTile("Taille", tll.toDouble(), 140, 220, "cm", (v) => setState(() => tll = v.toInt()))],
            if (step == 4) ...[const Text("Cible prioritaire d'entraînement", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.black)), const SizedBox(height: 25), ...['Full body', 'Pectoraux', 'Dos'].map((o) => buildTile("Objectif", obj, o, (v) => setState(() => obj = v)))],
            const Spacer(),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), onPressed: () => setState(() => step++), child: Text(step == 4 ? "GÉNÉRER MON ÉSPACE PRO" : "CONTINUER", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 15)))
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("VIPFIT ONLINE", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 2)), Text(currentTab == 0 ? "ÉNERGIE & QUOTAS" : "PROFIL & STRATÉGIE", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.black))]),
              IconButton(icon: const Icon(Icons.refresh, color: Colors.white38), onPressed: () => setState(() { step = 0; currentTab = 0; calPris = 0; eauPrise = 0; }))
            ]),
            const SizedBox(height: 15),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0x0F00FF66), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.bolt, color: Color(0xFF00FF66), size: 18), const SizedBox(width: 8), Expanded(child: Text(phraseMotivation, style: const TextStyle(color: Color(0xFF00FF66), fontSize: 12, fontWeight: FontWeight.w600)))]),),
            const SizedBox(height: 20),
            Expanded(child: SingleChildScrollView(child: currentTab == 0 ? Column(children: [
              buildDashboardCard("CALORIES RESTANTES", "${calCible - calPris} kcal restants", Icons.local_fire_department, Colors.orange, sub: "Objectif de base : $calCible kcal"),
              buildDashboardCard("EAU RESTANTE", "${eauCible - eauPrise} ml restants", Icons.water_drop, Colors.blue, sub: "Objectif hydratation : $eauCible ml"),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F1522), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => setState(() => calPris += 350), icon: const Icon(Icons.add, size: 16), label: const Text("Repas (+350 kcal)", style: TextStyle(fontSize: 12)))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F1522), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => setState(() => eauPrise += 500), icon: const Icon(Icons.add, size: 16), label: const Text("Eau (+500 ml)", style: TextStyle(fontSize: 12)))),
              ]),
            ]) : Column(children: [
              buildDashboardCard("COMPOSITION REQUIS", nutritionConseil, Icons.restaurant, const Color(0xFF00FF66)),
              buildDashboardCard("PLAN DE SÉANCE CIBLÉ", sportConseil, Icons.fitness_center, const Color(0xFF00E5FF)),
              buildDashboardCard("DONNÉES COMPLÈTES", "$sex • $age ans • $pds kg • $tll cm", Icons.assignment_ind, Colors.purpleAccent, sub: "Analyse dynamique active"),
            ]))),
            BottomNavigationBar(
              currentIndex: currentTab, onTap: (idx) => setState(() => currentTab = idx),
              backgroundColor: Colors.transparent, selectedItemColor: const Color(0xFF00FF66), unselectedItemColor: Colors.white24, elevation: 0,
              items: const [BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Tableau de Bord"), BottomNavigationBarItem(icon: Icon(Icons.shield), label: "Mon Plan Sport/Repas")]
            )
          ]),
        ),
      ),
    );
  }
}
