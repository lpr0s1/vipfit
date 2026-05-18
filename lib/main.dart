import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitZero()))));

class VipFitZero extends StatefulWidget {
  const VipFitZero({super.key});
  @override
  State<VipFitZero> createState() => _VipFitZeroState();
}

class _VipFitZeroState extends State<VipFitZero> {
  double poids = 70;
  double eau = 1.5;
  bool showPlan = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("VIPFIT ZERO", style: TextStyle(color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        
        if (!showPlan) ...[
          Text("Poids : ${poids.toInt()} kg", style: const TextStyle(color: Colors.white, fontSize: 20)),
          Slider(value: poids, min: 50, max: 120, activeColor: Colors.green, onChanged: (v) => setState(() => poids = v)),
          
          Text("Eau / jour : ${eau.toStringAsFixed(1)} L", style: const TextStyle(color: Colors.white, fontSize: 20)),
          Slider(value: eau, min: 1, max: 5, activeColor: Colors.green, onChanged: (v) => setState(() => eau = v)),
          
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => setState(() => showPlan = true),
            child: const Text("GÉNÉRER LE PLAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          // --- RÉSULTATS ---
          const Text("🎯 NUTRITION MASSE", style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Calories : ${(poids * 40).toInt()} kcal", style: const TextStyle(color: Colors.white, fontSize: 20)),
          Text("Protéines : ${(poids * 2.2).toInt()} g", style: const TextStyle(color: Colors.white, fontSize: 20)),
          Text(eau < 2.5 ? "⚠️ BOIS PLUS D'EAU !" : "✅ HYDRATATION OK", style: TextStyle(color: eau < 2.5 ? Colors.red : Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
          
          const SizedBox(height: 30),
          const Text("💪 ENTRAÎNEMENT", style: TextStyle(color: Colors.green, fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("• Dos / Biceps : Tractions & Curl Barre", style: TextStyle(color: Colors.white, fontSize: 18)),
          const Text("• Épaules / Triceps : Militaire & Dips", style: TextStyle(color: Colors.white, fontSize: 18)),
          const Text("• Cuisses / Mollets : Squat & Extensions", style: TextStyle(color: Colors.white, fontSize: 18)),
          const Text("• Avant-bras : Marche du Fermier", style: TextStyle(color: Colors.white, fontSize: 18)),
          
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => setState(() => showPlan = false),
            child: const Text("RETOUR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }
}
