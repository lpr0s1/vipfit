import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: VipFitLight()),
  debugShowCheckedModeBanner: false,
));

class VipFitLight extends StatefulWidget {
  const VipFitLight({super.key});
  @override
  State<VipFitLight> createState() => _VipFitLightState();
}

class _VipFitLightState extends State<VipFitLight> {
  // --- VARIABLES ---
  double age = 25;
  double poids = 70;
  double taille = 175;
  double eau = 1.5;
  double sommeil = 7;
  String sexe = "Homme";
  bool afficherPlan = false;

  // --- CALCULS BRUTS ---
  int get caloriesPriseDeMasse {
    double bmr = (sexe == "Homme") 
      ? 66 + (13.7 * poids) + (5 * taille) - (6.8 * age)
      : 655 + (9.6 * poids) + (1.8 * taille) - (4.7 * age);
    return (bmr * 1.55).toInt() + 400; // Maintenance + Surplus de masse
  }

  int get proteines => (poids * 2.2).toInt();

  @override
  Widget build(BuildContext context) {
    const vert = Color(0xFF00E676);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("VIPFIT", style: TextStyle(color: vert, fontSize: 32, fontWeight: FontWeight.black)),
          const Divider(color: Colors.white10, height: 30),

          if (!afficherPlan) ...[
            // === VUE 1 : FORMULAIRE ULTRA-PLAT ===
            DropdownButton<String>(
              value: sexe, dropdownColor: const Color(0xFF161F30), style: const TextStyle(color: vert, fontWeight: FontWeight.bold),
              items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => setState(() => sexe = v!),
            ),
            const SizedBox(height: 16),
            Text("Âge : ${age.toInt()} ans", style: const TextStyle(color: Colors.white)),
            Slider(value: age, min: 16, max: 60, activeColor: vert, onChanged: (v) => setState(() => age = v)),
            
            Text("Poids : ${poids.toInt()} kg", style: const TextStyle(color: Colors.white)),
            Slider(value: poids, min: 45, max: 120, activeColor: vert, onChanged: (v) => setState(() => poids = v)),
            
            Text("Taille : ${taille.toInt()} cm", style: const TextStyle(color: Colors.white)),
            Slider(value: taille, min: 140, max: 210, activeColor: vert, onChanged: (v) => setState(() => taille = v)),
            
            Text("Eau / jour : ${eau.toStringAsFixed(1)} L", style: const TextStyle(color: Colors.white)),
            Slider(value: eau, min: 0.5, max: 5.0, activeColor: vert, onChanged: (v) => setState(() => eau = v)),
            
            Text("Sommeil : ${sommeil.toInt()} heures", style: const TextStyle(color: Colors.white)),
            Slider(value: sommeil, min: 4, max: 10, activeColor: vert, onChanged: (v) => setState(() => sommeil = v)),
            
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: vert, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => afficherPlan = true),
              child: const Text("GÉNÉRER LE PLAN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // === VUE 2 : RÉSULTATS PLATS POUR CAPTURE ===
            const Text("🎯 NUTRITION MASSE", style: TextStyle(color: vert, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            Text("Objectif : $caloriesPriseDeMasse kcal / jour", style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text("Protéines : ${proteines}g", style: const TextStyle(color: Colors.white70)),
            Text(eau < 2.5 ? "⚠️ Attention : Bois minimum 2.5L d'eau !" : "💪 Hydratation validée", style: const TextStyle(color: Colors.orangeAccent)),
            
            const Divider(color: Colors.white10, height: 40),
            const Text("💪 ENTRAÎNEMENT CIBLE", style: TextStyle(color: vert, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            const Text("• Épaules/Bras : Développé Militaire & Curl Barre EZ", style: TextStyle(color: Colors.white)),
            const Text("• Poignets/Avant-bras : Curl Inversé & Marche du Fermier", style: TextStyle(color: Colors.white)),
            const Text("• Cuisses/Mollets : Squat lourd & Extensions debout", style: TextStyle(color: Colors.white)),
            
            if (sommeil < 8) ...[
              const SizedBox(height: 16),
              const Text("😴 Note : Dors plus pour maximiser la masse !", style: TextStyle(color: Colors.redAccent)),
            ],

            const SizedBox(height: 40),
            TextButton(
              onPressed: () => setState(() => afficherPlan = false),
              child: const Text("Modifier les informations", style: TextStyle(color: vert)),
            ),
          ],
        ],
      ),
    );
  }
}
