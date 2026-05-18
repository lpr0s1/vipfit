import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: BoxInvest())));

class BoxInvest extends StatefulWidget {
  const BoxInvest({super.key});
  @override
  State<BoxInvest> createState() => _BoxInvestState();
}

class _BoxInvestState extends State<BoxInvest> {
  double salaire = 2500;
  double age = 30;
  bool isZoneVerte = true; // True = Verte (Forte demande), False = Rouge (Saturée/Risquée)

  // Calculs de probabilités et rentabilité brute
  double get capaciteEmprunt => salaire * 0.35; // Règle des 35% d'endettement
  int get prixBoxMoyen => isZoneVerte ? 3500 : 6000; // Plus cher en zone saturée
  int get loyerMoyen => isZoneVerte ? 120 : 85; // Plus rentable là où il y a de la demande
  
  // Probabilité de réussite basée sur l'âge (accès crédit) et la zone
  double get probaReussite {
    double base = isZoneVerte ? 85.0 : 40.0;
    if (age < 21 || age > 60) base -= 15.0; // Profils plus compliqués pour les banques
    return base < 0 ? 0 : base;
  }

  double get gainEstimeMois => (capaciteEmprunt / 150) * loyerMoyen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Âge: ${age.toInt()} ans | Salaire: ${salaire.toInt()}€", style: const TextStyle(color: Colors.white, fontSize: 16)),
          Slider(value: age, min: 18, max: 75, activeColor: Colors.cyan, onChanged: (v) => setState(() => age = v)),
          Slider(value: salaire, min: 1200, max: 7000, activeColor: Colors.cyan, onChanged: (v) => setState(() => salaire = v)),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Zone Secteur : ", style: TextStyle(color: Colors.white)),
              Switch(value: isZoneVerte, activeColor: Colors.green, inactiveThumbColor: Colors.red, onChanged: (v) => setState(() => isZoneVerte = v)),
              Text(isZoneVerte ? "VERTE (Top)" : "ROUGE (Risque)", style: TextStyle(color: isZoneVerte ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(color: Colors.white24, height: 30),
          
          Text("Capacité d'emprunt max : ${capaciteEmprunt.toInt()} € / mois", style: const TextStyle(color: Colors.white)),
          Text("Probabilité de succès du projet : ${probaReussite.toInt()}%", style: TextStyle(color: probaReussite > 50 ? Colors.greenAccent : Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Gain estimé : ~${gainEstimeMois.toInt()} € / mois", style: const TextStyle(color: Colors.cyan, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
