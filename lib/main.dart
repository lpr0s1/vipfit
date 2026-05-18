import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFit())),
  debugShowCheckedModeBanner: false,
));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  bool show = false;
  String sexe = "Homme";
  int poids = 75;
  int reveil = 7;

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);
    
    // Algorithmes de calculs nutritionnels VIP directes
    int cal = (sexe == "Homme" ? (10 * poids + 500) : (10 * poids + 200)) + 500;
    int prot = (poids * 2.2).toInt();
    int noix = (poids * 0.4).toInt();
    int pistache = (poids * 0.5).toInt();
    int hNoix = (reveil + 3) % 24;
    int hPistache = (reveil + 9) % 24;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // --- HEADER VIP ---
        Row(
          children: [
            const Icon(Icons.star, color: gold, size: 26),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("VIP FIT LAB", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text("PROTOCOLE HORAIRE & PERFORMANCE", style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 9)),
              ],
            )
          ],
        ),
        const Divider(color: Colors.white10, height: 30),

        if (!show) ...[
          // === VUE COMPILATION ULTRALÉGÈRE (BOUTONS +/-) ===
          const Text("PARAMÈTRES DE L'ATHLÈTE", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Sexe Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [Icon(Icons.person, color: gold, size: 20), SizedBox(width: 10), Text("Sexe biologique", style: TextStyle(color: Colors.white70, fontSize: 14))]),
              DropdownButton<String>(
                value: sexe, dropdownColor: Colors.grey[900], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                underline: Container(),
                items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => sexe = v!),
              )
            ],
          ),
          const Divider(color: Colors.white10, height: 25),

          // Poids Sélecteur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [Icon(Icons.scale, color: gold, size: 20), SizedBox(width: 10), Text("Poids corporel", style: TextStyle(color: Colors.white70, fontSize: 14))]),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove_circle_outline, color: gold), onPressed: () => setState(() => poids--)),
                  Text("$poids kg", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  IconButton(icon: const Icon(Icons.add_circle_outline, color: gold), onPressed: () => setState(() => poids++)),
                ],
              )
            ],
          ),
          const Divider(color: Colors.white10, height: 25),

          // Réveil Sélecteur
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(children: [Icon(Icons.alarm, color: gold, size: 20), SizedBox(width: 10), Text("Heure de réveil", style: TextStyle(color: Colors.white70, fontSize: 14))]),
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.remove_circle_outline, color: gold), onPressed: () => setState(() => reveil = reveil > 0 ? reveil - 1 : 23)),
                  Text("${reveil}h00", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  IconButton(icon: const Icon(Icons.add_circle_outline, color: gold), onPressed: () => setState(() => reveil = (reveil + 1) % 24)),
                ],
              )
            ],
          ),

          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => show = true),
            child: const Text("GÉNÉRER LE PROTOCOLE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          ),
        ] else ...[
          // === VUE RÉSULTATS : COMPACTE ET PRESTIGE ===
          const Text("🎯 MACRONUTRITION SUR-MESURE", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Volume Énergétique", style: TextStyle(color: Colors.white70, fontSize: 13)), Text("$cal kcal / jour", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Protéines structurales", style: TextStyle(color: Colors.white70, fontSize: 13)), Text("${prot}g / jour", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
          
          const Divider(color: Colors.white10, height: 25),

          const Text("⏳ TIMING PROTOCOLE HORAIRE", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          
          Row(children: [const Icon(Icons.bolt, color: gold, size: 16), const SizedBox(width: 6), Text("$hNoix h00 - Collation Articulations", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 4, bottom: 15),
            child: Text("Prendre précisément $noix g de Noix de Grenoble (acides gras Oméga-3). Objectif : lubrifier les tendons et protéger les articulations des poignets/coudes avant d'attaquer les barres lourdes.", style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          ),

          Row(children: [const Icon(Icons.bolt, color: gold, size: 16), const SizedBox(width: 6), Text("$hPistache h00 - Vasodilatation Musculaire", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 4, bottom: 15),
            child: Text("Consommer $pistache g de Pistaches crues (non salées). Sa haute teneur en L-Arginine stimule l'oxyde nitrique : idéal 30 min avant ton bloc d'effort pour saturer les biceps et les avant-bras de sang.", style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          ),

          const Divider(color: Colors.white10, height: 25),
          const Text("⚔️ MÉCANIQUE D'ISOLATION ANABOLIQUE", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          const Text("Membres Supérieurs & Grip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          const Text("• SuperSet Biceps/Triceps : Curl incliné + Dips lestés (4x10)\n• Avant-bras : Curl inversé barre EZ (3x12) + Flexions poignets (3x15)", style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
          
          const SizedBox(height: 12),
          const Text("Membres Inférieurs", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          const Text("• Cuisses & Ischios : Squat lourd complet (4x6) + Terre roumain (3x8)\n• Mollets : Extensions debout sur bloc (5x20, pause de 2s en étirement)", style: TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),

          const Divider(color: Colors.white10, height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: gold, width: 0.5), minimumSize: const Size(double.infinity, 45), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => show = false),
            child: const Text("MODIFIER LES INFOS", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ]
      ],
    );
  }
}
