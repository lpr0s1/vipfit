import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitPro())),
  debugShowCheckedModeBanner: false,
));

class VipFitPro extends StatefulWidget {
  const VipFitPro({super.key});
  @override
  State<VipFitPro> createState() => _VipFitProState();
}

class _VipFitProState extends State<VipFitPro> {
  bool showPlan = false;

  // --- RECOLTE D'INFORMATIONS CRUCIALES & UTILES ---
  String sexe = "Homme";
  double age = 25;
  double poids = 75;
  double taille = 175;
  double reveil = 7;
  double eau = 2.0;
  double sommeil = 7;
  double restoParSemaine = 2;

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37); // Or VIP
    const Color darkGrey = Color(0xFF1C1C1E); // Gris Premium

    // --- ALGORITHME DE CALCUL DES MACROS ET PROTOCOLES HORAIRES ---
    int surplusResto = (restoParSemaine > 3) ? 200 : 450; // Moins de surplus si bcp de resto cachés
    double bmr = (sexe == "Homme") 
        ? (10 * poids) + (6.25 * taille) - (5 * age) + 5 
        : (10 * poids) + (6.25 * taille) - (5 * age) - 161;
    int caloriesCibles = (bmr * 1.5).toInt() + surplusResto;
    int proteinesCibles = (poids * 2.2).toInt();

    // Calculs précis au gramme près pour la performance
    int gramNoix = (poids * 0.4).toInt(); 
    int gramPistache = (poids * 0.5).toInt();
    int heureNoix = (reveil + 3).toInt() % 24;
    int heurePistache = (reveil + 9).toInt() % 24;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // HEADER ATHLÈTE VIP
        Row(
          children: [
            const Icon(Icons.fitness_center, color: gold, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("VIP FIT LAB", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text("PROTOCOLE DE MASSE ATHLÉTIQUE", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9, letterSpacing: 0.5)),
              ],
            )
          ],
        ),
        const Divider(color: Colors.white10, height: 30),

        if (!showPlan) ...[
          // === VUE 1 : FORMULAIRE COMPLET ET DESIGN ===
          const Text("ANALYSE DES PARAMÈTRES", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 15),

          // Sexe
          ListTile(
            leading: const Icon(Icons.person, color: gold),
            title: const Text("Sexe biologique", style: TextStyle(color: Colors.white70, fontSize: 14)),
            trailing: DropdownButton<String>(
              value: sexe, dropdownColor: darkGrey, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              underline: Container(),
              items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => sexe = v!),
            ),
          ),
          
          // Âge
          ListTile(
            leading: const Icon(Icons.cake, color: gold),
            title: Text("Âge : ${age.toInt()} ans", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: age, min: 16, max: 60, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => age = v)),
          ),

          // Poids
          ListTile(
            leading: const Icon(Icons.monitor_weight, color: gold),
            title: Text("Poids corporel : ${poids.toInt()} kg", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: poids, min: 50, max: 120, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => poids = v)),
          ),

          // Taille
          ListTile(
            leading: const Icon(Icons.straighten, color: gold),
            title: Text("Taille : ${taille.toInt()} cm", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: taille, min: 140, max: 210, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => taille = v)),
          ),

          // Réveil
          ListTile(
            leading: const Icon(Icons.alarm, color: gold),
            title: Text("Heure de réveil : ${reveil.toInt()}h00", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: reveil, min: 5, max: 11, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => reveil = v)),
          ),

          // Hydratation
          ListTile(
            leading: const Icon(Icons.water_drop, color: gold),
            title: Text("Hydratation : ${eau.toStringAsFixed(1)} Litres / jour", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: eau, min: 1, max: 5, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => eau = v)),
          ),

          // Sommeil
          ListTile(
            leading: const Icon(Icons.bed, color: gold),
            title: Text("Sommeil total : ${sommeil.toInt()} heures / nuit", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: sommeil, min: 4, max: 10, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => sommeil = v)),
          ),

          // Restaurants / Écarts
          ListTile(
            leading: const Icon(Icons.restaurant, color: gold),
            title: Text("Fréquence Restaurants / Écarts : ${restoParSemaine.toInt()} x par semaine", style: const TextStyle(color: Colors.white70, fontSize: 14)),
            subtitle: Slider(value: restoParSemaine, min: 0, max: 7, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => restoParSemaine = v)),
          ),

          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 52), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = true),
            child: const Text("CALCULER MON PROTOCOLE D'ÉLITE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
        ] else ...[
          // === VUE 2 : PROTOCOLE INTÉGRAL CONDENSÉ (POUR SCREENSHOT) ===
          const Center(child: Text("📸 PRENDS UNE CAPTURE D'ÉCRAN DE TON PLAN", style: TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold))),
          const SizedBox(height: 15),

          // BLOC MACRONUTRITION UTULITAIRE
          const Text("🎯 DIÈTE DE MASSE PRÉCISE", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Objectif Énergétique", style: TextStyle(color: Colors.white70, fontSize: 13)), Text("$caloriesCibles kcal / jour", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Protéines de construction", style: TextStyle(color: Colors.white70, fontSize: 13)), Text("${proteinesCibles}g / jour", style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
          
          const Divider(color: Colors.white10, height: 25),

          // BLOC CONSEILS HORAIRES ET BIOMÉCANIQUES (NOIX & PISTACHES)
          const Text("⏳ TIMING PROTOCOLE NUTRITIONNEL", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          Text("• $heureNoix h00 | Collation Noix : Consommer exactement $gramNoix g de Noix de Grenoble. Riches en acides gras essentiels (Oméga-3) pour lubrifier les articulations et protéger les poignets et les coudes des blessures lors des poussées lourdes.", style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.4)),
          const SizedBox(height: 10),
          Text("• $heurePistache h00 | Fenêtre de Congestion : Prendre $gramPistache g de Pistaches (crues et non salées) 30 minutes avant l'effort. Sa haute teneur en L-Arginine booste naturellement l'oxyde nitrique, provoquant une vasodilatation massive pour gorger les biceps et avant-bras de sang.", style: const TextStyle(color: Colors.white60, fontSize: 11, height: 1.4)),

          const Divider(color: Colors.white10, height: 25),

          // BLOC ENTRAÎNEMENT PAR ZONES SPÉCIFIQUES
          const Text("⚔️ ENTRAÎNEMENT MUSCULAIRE CIBLÉ", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          Text("Membres Supérieurs (Bras, Épaules, Dos, Poignets)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          Text("• Dos / Épaules : Tractions strictes pronation (4xMax) + Développé militaire barre (4x8)\n• Biceps / Triceps : Curl incliné sur banc + Dips barre parallèle lestés (4x10)\n• Avant-bras / Poignets : Curl inversé poulie basse (3x12) + Flexions de poignets assis avec haltères courts (3x15)", style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          
          const SizedBox(height: 12),
          
          Text("Membres Inférieurs (Cuisses, Mollets)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          Text("• Cuisses / Jambes : Squat lourd complet (4x6) + Soulevé de terre jambes tendues (3x8)\n• Mollets : Extension mollets debout (5x20) avec temps d'arrêt de 2 secondes en bas en étirement complet.", style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),

          const Divider(color: Colors.white10, height: 25),

          // ALERTES RECUPÉRATION (EAU & SOMMEIL)
          if (eau < 3.0 || sommeil < 8) ...[
            const Text("⚠️ ALERTES DE SÉCURITÉ ANABOLIQUE", style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
            if (eau < 3.0) const Text("• Hydratation trop faible (${eau}L). Risque élevé de tendinite aux poignets. Monte impérativement à 3.5L.", style: TextStyle(color: Colors.white54, fontSize: 11)),
            if (sommeil < 8) const Text("• Récupération nerveuse critique (${sommeil}h). Le muscle se reconstruit pendant la phase profonde. Vise 8h minimum.", style: TextStyle(color: Colors.white54, fontSize: 11)),
            const SizedBox(height: 25),
          ],

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: gold, width: 0.5), minimumSize: const Size(double.infinity, 45), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = false),
            child: const Text("MODIFIER MES CONFIGURATIONS", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]
      ],
    );
  }
}
