import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: VipFitElite()),
  debugShowCheckedModeBanner: false,
));

class VipFitElite extends StatefulWidget {
  const VipFitElite({super.key});
  @override
  State<VipFitElite> createState() => _VipFitEliteState();
}

class _VipFitEliteState extends State<VipFitElite> {
  // --- DONNÉES ANTHROPOMÉTRIQUES ---
  double age = 25;
  double poids = 70; // en kg
  double taille = 175; // en cm
  String sexe = "Homme";
  
  // --- HYGIÈNE DE VIE & DIÈTE ---
  String typeAlimentation = "Classique (Omnivore)";
  bool souventAuResto = false;
  double eauLitres = 1.5;
  double heuresSommeil = 7;

  bool afficherPlan = false;

  // --- LOGIQUE DE CALCUL DE MASS GAIN ---
  // Calcul du Métabolisme de Base (Formule de Harris-Benedict simplifiée)
  int get caloriesMaintenance {
    double bmr = 0;
    if (sexe == "Homme") {
      bmr = 66.47 + (13.75 * poids) + (5.0 * taille) - (6.75 * age);
    } else {
      bmr = 655.1 + (9.56 * poids) + (1.85 * taille) - (4.68 * age);
    }
    // On applique un facteur d'activité moyen pour la musculation (x 1.55)
    return (bmr * 1.55).toInt();
  }

  // Surplus calorique pour la prise de masse (+350 à +500 kcal selon le profil)
  int get caloriesPriseDeMasse {
    int surplus = souventAuResto ? 350 : 450; // On baisse le surplus si déjà bcp de resto cachés
    return caloriesMaintenance + surplus;
  }

  // Macronutriments cibles
  int get proteinesCibles => (poids * 2.2).toInt(); // 2.2g par kg de poids de corps
  int get lipidesCibles => poids.toInt(); // 1g par kg de poids de corps

  // Analyse hydratation / sommeil
  String get alerteRecup {
    String diagnostic = "";
    if (eauLitres < 2.5) diagnostic += "💧 Augmente l'eau à 3L/jour pour éviter les tendinites aux poignets.\n";
    if (heuresSommeil < 8) diagnostic += "😴 Dors 8h minimum, le muscle se construit pendant le sommeil, pas à la salle !";
    if (diagnostic.isEmpty) diagnostic = "✅ Hydratation & Sommeil parfaits pour l'anabolisme !";
    return diagnostic;
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF00E676); // Couleur Fitness Énergie

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("VIPFIT EVOLUTION", style: TextStyle(color: neonGreen, fontSize: 26, fontWeight: FontWeight.black, letterSpacing: 1.5)),
          const Text("Objectif : Prise de Masse Maximale", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const Divider(color: Colors.white10, height: 30),

          if (!afficherPlan) ...[
            // === VUE 1 : COLLECTE DES INFOS ===
            _sectionTitle("1. Profil Physique"),
            _card(Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("Sexe :", style: TextStyle(color: Colors.white70)),
                DropdownButton<String>(
                  value: sexe, dropdownColor: const Color(0xFF161F30), style: const TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
                  items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (v) => setState(() => sexe = v!),
                )
              ]),
              _sliderLabel("Âge : ${age.toInt()} ans"),
              Slider(value: age, min: 16, max: 60, activeColor: neonGreen, onChanged: (v) => setState(() => age = v)),
              _sliderLabel("Poids : ${poids.toInt()} kg"),
              Slider(value: poids, min: 45, max: 120, activeColor: neonGreen, onChanged: (v) => setState(() => poids = v)),
              _sliderLabel("Taille : ${taille.toInt()} cm"),
              Slider(value: taille, min: 140, max: 210, activeColor: neonGreen, onChanged: (v) => setState(() => taille = v)),
            ])),

            _sectionTitle("2. Nutrition & Récupération"),
            _card(Column(children: [
              DropdownButton<String>(
                value: typeAlimentation, isExpanded: true, dropdownColor: const Color(0xFF161F30), style: const TextStyle(color: Colors.white),
                items: ["Classique (Omnivore)", "Hyperprotéiné", "Végétarien / Végan"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => typeAlimentation = v!),
              ),
              SwitchListTile(
                title: const Text("Manges-tu souvent au restaurant ?", style: TextStyle(color: Colors.white70, fontSize: 13)),
                value: souventAuResto, activeColor: neonGreen, onChanged: (v) => setState(() => souventAuResto = v),
              ),
              _sliderLabel("Eau par jour : ${eauLitres.toStringAsFixed(1)} Litre(s)"),
              Slider(value: eauLitres, min: 0.5, max: 5.0, divisions: 9, activeColor: neonGreen, onChanged: (v) => setState(() => eauLitres = v)),
              _sliderLabel("Sommeil par nuit : ${heuresSommeil.toInt()} heures"),
              Slider(value: heuresSommeil, min: 4, max: 10, activeColor: neonGreen, onChanged: (v) => setState(() => heuresSommeil = v)),
            ])),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: neonGreen, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => setState(() => afficherPlan = true),
              child: const Text("GÉNÉRER MON PLAN SCREENSHOT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // === VUE 2 : PLAN PARFAIT À CAPTURER ===
            const Center(child: Text("📸 PRENDS UN SCREENSHOT DE TON PLAN", style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold))),
            const SizedBox(height: 15),

            // Bloc nutrition
            _sectionTitle("🎯 DIÈTE DE MASSE PERSONNALISÉE"),
            _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _rowResult("Objectif Journalier", "$caloriesPriseDeMasse kcal"),
              _rowResult("Protéines (Bâtisseur)", "${proteinesCibles}g"),
              _rowResult("Lipides (Hormones)", "${lipidesCibles}g"),
              const Divider(color: Colors.white10),
              Text(alerteRecup, style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, height: 1.4)),
            ])),

            // Bloc Entraînement
            _sectionTitle("💪 PROGRAMME DE MUSCULATION CIBLE"),
            
            _exoBox("HAUT DU CORPS (Épaules & Bras & Dos)", 
              "• Épaules : Développé Militaire (4x8) + Élévations Latérales (3x15)\n"
              "• Dos : Tractions Lestées ou Tirage Poitrine (4x8)\n"
              "• Biceps : Curl Barre EZ (3x10)\n"
              "• Triceps : Barre au Front (3x10)"
            ),
            
            _exoBox("AVANT-BRAS & POIGNETS (Force de poigne)", 
              "• Avanti-bras : Curl Inversé à la barre (3x12)\n"
              "• Poignets : Extension & Flexion poignets assis (3x15)\n"
              "• Grip : Marche du fermier (Farmer Walk) (3 séries à l'échec)"
            ),

            _exoBox("BAS DU CORPS (Cuisses & Mollets)", 
              "• Cuisses : Squat lourd (4x6) + Presse à cuisses (3x10)\n"
              "• Jambes (Ischios) : Soulevé de terre jambes tendues (4x8)\n"
              "• Mollets : Extensions mollets debout (4x20 avec contraction 2s)"
            ),

            const SizedBox(height: 30),
            Center(
              child: TextButton.icon(
                onPressed: () => setState(() => afficherPlan = false),
                icon: const Icon(Icons.edit, color: neonGreen),
                label: const Text("Modifier mon profil physique", style: TextStyle(color: neonGreen)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- STRUCTURES COMPOSANTS ULTRA-LÉGÈRES (Anti-crash Xcode) ---
  Widget _sectionTitle(String t) => Padding(padding: const EdgeInsets.only(top: 20, bottom: 10), child: Text(t, style: const TextStyle(color: Color(0xFF00E676), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)));

  Widget _sliderLabel(String t) => Padding(padding: const EdgeInsets.only(top: 12), child: Align(alignment: Alignment.centerLeft, child: Text(t, style: const TextStyle(color: Colors.white80, fontSize: 13))));

  Widget _card(Widget child) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFF161F30), borderRadius: BorderRadius.circular(12)), child: child);

  Widget _rowResult(String label, String val) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70)), Text(val, style: const TextStyle(color: Color(0xFF00E676), fontSize: 18, fontWeight: FontWeight.bold))]));

  Widget _exoBox(String zone, String listeExos) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: _card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(zone, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text(listeExos, style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.5)),
    ])),
  );
}
