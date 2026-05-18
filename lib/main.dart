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
  double poids = 75;
  double reveil = 7;

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);
    
    // Calculs directs au gramme et à l'heure près
    final int gramNoix = (poids * 0.4).toInt();
    final int gramPistache = (poids * 0.5).toInt();
    final int heureNoix = (reveil + 3).toInt();
    final int heurePistache = (reveil + 9).toInt();

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text("VIP FIT PROTOCOL", style: TextStyle(color: gold, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1)),
        const Divider(color: Colors.white10, height: 30),

        if (!show) ...[
          // --- VUE 1 : INPUTS UTILES ---
          Text("Poids actuel : ${poids.toInt()} kg", style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Slider(value: poids, min: 50, max: 120, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => poids = v)),
          
          const SizedBox(height: 15),
          Text("Heure de réveil : ${reveil.toInt()}h00", style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Slider(value: reveil, min: 5, max: 11, activeColor: gold, inactiveColor: Colors.white10, onChanged: (v) => setState(() => reveil = v)),
          
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => show = true),
            child: const Text("GÉNÉRER LE PLAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          // --- VUE 2 : PROTOCOLE VIP (PARFAIT POUR SCREENSHOT) ---
          const Text("⏳ TIMING NUTRITIONNEL", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          Text("$heureNoix h00 - Collation Articulations", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text("• $gramNoix g de Noix de Grenoble.\n• Protection des poignets et coudes (Oméga-3) pour soulever lourd.", style: const TextStyle(color: Colors.white54, fontSize: 11)),
          
          const SizedBox(height: 15),
          Text("$heurePistache h00 - Collation Congestion (Pré-training)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text("• $gramPistache g de Pistaches crues.\n• Riches en L-Arginine : booste l'afflux sanguin vers les biceps et avant-bras.", style: const TextStyle(color: Colors.white54, fontSize: 11)),
          
          const Divider(color: Colors.white10, height: 30),
          const Text("⚔️ ENTRAÎNEMENT HAUTE INTENSITÉ", style: TextStyle(color: gold, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          const Text("Bras, Avant-bras & Poignets", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          const Text("• SuperSet Curl incliné + Dips lestés (4x10)\n• Curl inversé barre EZ (3x12) + Flexions poignets (3x15)", style: TextStyle(color: Colors.white54, fontSize: 11)),
          
          const SizedBox(height: 15),
          const Text("Cuisses, Mollets & Dos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          const Text("• Squat lourd (4x6) + Extensions mollets debout (5x20 avec pause en bas)\n• Tractions strictes pronation (4xMax)", style: TextStyle(color: Colors.white54, fontSize: 11)),
          
          const Divider(color: Colors.white10, height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, side: const BorderSide(color: gold, width: 0.5), minimumSize: const Size(double.infinity, 45), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => show = false),
            child: const Text("MODIFIER", style: TextStyle(color: gold, fontSize: 12)),
          ),
        ]
      ],
    );
  }
}
