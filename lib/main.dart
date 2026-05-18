import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: WealthVisionUltimate())));

class WealthVisionUltimate extends StatefulWidget {
  const WealthVisionUltimate({super.key});
  @override
  State<WealthVisionUltimate> createState() => _WealthVisionUltimateState();
}

class _WealthVisionUltimateState extends State<WealthVisionUltimate> {
  // --- VARIABLES ---
  double salaire = 2500;
  double capitalTrading = 10000;
  String destinationExpat = "France";
  bool isPropFirm = false; 
  bool afficherResultat = false;

  // --- CALCULS ---
  double get gainTradingBrut => capitalTrading * 0.05; // 5% par mois

  double get gainTradingNet => isPropFirm ? gainTradingBrut * 0.80 : gainTradingBrut * 0.70;

  int get coutVieDestination {
    if (destinationExpat == "Bali") return 1200;
    if (destinationExpat == "Dubaï") return 3500;
    return 2000; 
  }

  double get resteApresImpotExpat {
    double revenusTotaux = salaire + gainTradingNet;
    if (destinationExpat == "Dubaï") return revenusTotaux; 
    if (destinationExpat == "Bali") return revenusTotaux * 0.90; 
    return revenusTotaux * 0.80; 
  }

  double get resteAVivreFinal => resteApresImpotExpat - coutVieDestination;

  String get diagnosticExpat {
    if (resteAVivreFinal < 0) return "Projet Impossible : Revenus insuffisants pour ce pays.";
    if (resteAVivreFinal < 1000) return "Projet Risqué : Budget trop serré sur place.";
    return "Projet Validé ! Excellent niveau de vie en perspective.";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("WealthVision Évolution", style: TextStyle(color: Colors.cyan, fontSize: 26, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white10, height: 32),

          if (!afficherResultat) ...[
            // === FORMULAIRE ===
            const Text("1. Vos Revenus Actuels", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Salaire Pro : ${salaire.toInt()} €/mois", style: const TextStyle(color: Colors.white)),
            Slider(value: salaire, min: 0, max: 10000, activeColor: Colors.cyan, onChanged: (v) => setState(() => salaire = v)),
            
            const SizedBox(height: 16),
            const Text("2. Trading & Capital (FTMO)", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Taille du compte : ${capitalTrading.toInt()} €", style: const TextStyle(color: Colors.white)),
            Slider(value: capitalTrading, min: 2000, max: 200000, activeColor: Colors.cyan, onChanged: (v) => setState(() => capitalTrading = v)),
            
            Row(
              children: [
                const Text("Compte Prop Firm (FTMO) ?", style: TextStyle(color: Colors.white70)),
                Checkbox(
                  value: isPropFirm,
                  activeColor: Colors.cyan,
                  onChanged: (v) => setState(() => isPropFirm = v!),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text("3. Objectif Expatriation", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: destinationExpat,
              dropdownColor: const Color(0xFF161F30),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "France", child: Text("Rester en France 🇫🇷")),
                DropdownMenuItem(value: "Bali", child: Text("Partir à Bali 🇮🇩")),
                DropdownMenuItem(value: "Dubaï", child: Text("Partir à Dubaï 🇦🇪")),
              ],
              onChanged: (v) => setState(() => destinationExpat = v!),
            ),
            
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => afficherResultat = true),
              child: const Text("SIMULER L'EXPATRIATION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // === RÉSULTATS ===
            Text("DESTINATION : $destinationExpat", style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            Text("Gain Trading net estimé : ${gainTradingNet.toInt()} € / mois", style: const TextStyle(color: Colors.white70)),
            Text(isPropFirm ? "(Payout FTMO à 80% inclus)" : "(Flat-tax 30% incluse)", style: const TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 16),

            Text("Coût de la vie sur place : ${coutVieDestination} € / mois", style: const TextStyle(color: Colors.orangeAccent)),
            const Divider(color: Colors.white10, height: 32),

            const Text("Reste à vivre RÉEL sur place :", style: TextStyle(color: Colors.white54)),
            Text("${resteAVivreFinal.toInt()} € / mois", style: const TextStyle(color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 24),
            Text(diagnosticExpat, style: TextStyle(color: resteAVivreFinal > 1000 ? Colors.green : Colors.redAccent, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () => setState(() => afficherResultat = false),
              icon: const Icon(Icons.arrow_back, color: Colors.cyan),
              label: const Text("Modifier mes informations", style: TextStyle(color: Colors.cyan)),
            ),
          ],
        ],
      ),
    );
  }
}
