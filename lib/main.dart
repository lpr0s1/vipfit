import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitProtocol()))));

class VipFitProtocol extends StatefulWidget {
  const VipFitProtocol({super.key});
  @override
  State<VipFitProtocol> createState() => _VipFitProtocolState();
}

class _VipFitProtocolState extends State<VipFitProtocol> {
  bool showPlan = false;

  // UNIQUEMENT LES INFOS UTILES
  double poids = 75;
  double heureReveil = 7; // ex: 7h00
  String niveau = "Intermédiaire";

  // CALCULS DU TIMING NUTRITIONNEL VIP
  String get tempsNoix => "${(heureReveil + 3).toInt()}h00"; // 3h après le réveil
  String get tempsPistaches => "${(heureReveil + 9).toInt()}h00"; // Pré-repas/Pré-training après-midi

  int get grammesPistaches => (poids * 0.5).toInt(); // ~35-40g calibré selon le poids
  int get grammesNoix => (poids * 0.4).toInt(); // ~30g pour les lipides articulaires

  @override
  Widget build(BuildContext context) {
    const Color vipGold = Color(0xFFD4AF37); // Or Satiné VIP
    const Color charcoal = Color(0xFF1C1C1E); // Gris sombre premium

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        // HEADER PREMIUM
        const Text("VIP FIT PROTOCOL", style: TextStyle(color: vipGold, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        const Text("SYNTHÈSE NUTRITIONNELLE ET TIMING DE PERFORMANCE", style: TextStyle(color: Colors.white30, fontSize: 9, letterSpacing: 0.5)),
        const Divider(color: Colors.white10, height: 30),

        if (!showPlan) ...[
          // IMPUTS CHIRURGICAUX
          const Text("VOS MÉTRIQUES DE BASE", style: TextStyle(color: vipGold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),

          _label("Poids actuel : ${poids.toInt()} kg"),
          Slider(value: poids, min: 50, max: 120, activeColor: vipGold, inactiveColor: charcoal, onChanged: (v) => setState(() => poids = v)),

          _label("Heure habituelle de réveil : ${heureReveil.toInt()}h00"),
          Slider(value: heureReveil, min: 5, max: 11, divisions: 6, activeColor: vipGold, inactiveColor: charcoal, onChanged: (v) => setState(() => heureReveil = v)),

          _label("Niveau d'expérience mécanique"),
          DropdownButton<String>(
            value: niveau, dropdownColor: charcoal, style: const TextStyle(color: Colors.white, fontSize: 13),
            underline: Container(height: 1, color: vipGold),
            isExpanded: true,
            items: ["Débutant", "Intermédiaire", "Athlète Élite"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => niveau = v!),
          ),

          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: vipGold, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = true),
            child: const Text("GÉNÉRER LE PROTOCOLE HORAIRE", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
          ),
        ] else ...[
          // PLAN HIGH-DENSITY POUR SCREENSHOT (TEXTE PETIT ET PRÉCIS)
          const Text("⏳ TIMING PROTOCOLE NUTRITION (SURPLUS MACROS)", style: TextStyle(color: vipGold, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          
          _nutriRow("$tempsNoix - Collation Option Anabolique", "• $grammesNoix g de Noix de Grenoble\n• Protège les articulations (poignets/coudes) lors des charges lourdes.\n• Apport en acides gras essentiels (Oméga-3)."),
          _nutriRow("$tempsPistaches - Fenêtre de Pré-Congestion", "• Consommer exactement $grammesPistaches g de Pistaches (crues, non salées).\n• À prendre 30 minutes avant le repas ou l'entraînement.\n• Riches en L-Arginine : favorise l'oxyde nitrique, la vasodilatation et l'afflux sanguin vers les bras/biceps."),
          
          const Divider(color: Colors.white10, height: 25),
          
          const Text("⚔️ AXE D'ISOLATION MUSCULAIRE", style: TextStyle(color: vipGold, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          const SizedBox(height: 10),
          _exoRow("Membres Supérieurs (Bras, Avant-bras, Poignets)", "• Biceps/Triceps : SuperSet Curl incliné + Dips lestés (4 x 10 répétitions)\n• Avant-bras : Curl inversé à la barre EZ (3 x 12, contrôle excentrique)\n• Poignets : Flexions au banc avec haltères courts (3 x 15, grosse contraction en haut)"),
          _exoRow("Membres Inférieurs & Postérieurs (Cuisses, Mollets, Dos)", "• Cuisses/Jambes : Squat lourd (4x6) + Soulevé de terre roumain (3x8)\n• Mollets : Extensions debout (5x20) avec pause d'arrêt de 2 secondes en bas\n• Fixateurs du Dos : Tractions strictes pronation (4 x Maximum de reps)"),

          const Divider(color: Colors.white10, height: 35),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: vipGold, width: 0.5), minimumSize: const Size(double.infinity, 42), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => showPlan = false),
            child: const Text("AJUSTER LES HORAIRES / POIDS", style: TextStyle(color: vipGold, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ]
      ],
    );
  }

  // COMPOSANTS RADICAUX ET ULTRA-LÉGERS
  Widget _label(String t) => Padding(padding: const EdgeInsets.only(top: 14, bottom: 4), child: Text(t, style: const TextStyle(color: Colors.whiteBneutral, fontSize: 12, color: Colors.white70)));

  Widget _nutriRow(String time, String details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(details, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }

  Widget _exoRow(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white90, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(desc, style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 11, height: 1.4)),
        ],
      ),
    );
  }
}
