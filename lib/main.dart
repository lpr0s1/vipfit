import 'package:flutter/material.dart';
void main() => runApp(const MaterialApp(home: VipFit(), debugShowCheckedModeBanner: false));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int page = 0, age = 22, pds = 70, calPris = 0, eauPrise = 0;
  String obj = 'Full body'; // Profil / Cible

  // Calcul du métabolisme de base (Calories) et Eau cible
  int get calCible => (obj == 'Pectoraux' || obj == 'Dos') ? (10 * pds + 1800) : (10 * pds + 1400);
  int get eauCible => pds * 35; // 35ml par kg

  Widget card(String t, String v, IconData i, Color c) => Container(
    margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF0F1522), borderRadius: BorderRadius.circular(16)),
    child: Row(children: [Icon(i, color: c), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(color: Colors.white54, fontSize: 12)), Text(v, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))])]),
  );

  @override
  Widget build(BuildContext context) {
    // Adaptation dynamique du repas selon le profil
    String repas = obj == 'Full body' ? "Poulet, Riz, Légumes vert (Léger)" : "Bœuf haché, Pâtes, Œufs (Prise de muscle)";
    
    return Scaffold(
      backgroundColor: const Color(0xFF06090E),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: page == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("PROFIL VIPFIT", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold, letterSpacing: 2)),
          const SizedBox(height: 20),
          ...['Full body', 'Pectoraux', 'Dos'].map((o) => RadioListTile(title: Text(o, style: const TextStyle(color: Colors.white)), value: o, groupValue: obj, onChanged: (v) => setState(() => obj = v!))),
          const Text("Votre poids (kg) :", style: TextStyle(color: Colors.white)),
          Slider(value: pds.toDouble(), min: 40, max: 120, activeColor: const Color(0xFF00FF66), onChanged: (v) => setState(() => pds = v.toInt())),
          const Spacer(),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FF66), minimumSize: const Size(double.infinity, 50)), onPressed: () => setState(() => page = 1), child: const Text("ACCÉDER AU DASHBOARD", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("SUIVI ÉLITE", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          card("CALORIES RESTANTES", "${calCible - calPris} kcal / $calCible", Icons.local_fire_department, Colors.orange),
          card("EAU RESTANTE", "${eauCible - eauPrise} ml / $eauCible", Icons.water_drop, Colors.blue),
          card("REPAS ADAPTÉ (${obj})", repas, Icons.restaurant, const Color(0xFF00FF66)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: ElevatedButton(onPressed: () => setState(() => calPris += 500), child: const Text("+500 kcal"))),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton(onPressed: () => setState(() => eauPrise += 500), child: const Text("+500 ml"))),
          ]),
          const Spacer(),
          TextButton(onPressed: () => setState(() => page = 0), child: const Center(child: Text("Modifier le profil", style: TextStyle(color: Colors.white38))))
        ]),
      )),
    );
  }
}
