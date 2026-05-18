import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: BudgetCalcul())));

class BudgetCalcul extends StatefulWidget {
  const BudgetCalcul({super.key});
  @override
  State<BudgetCalcul> createState() => _BudgetCalculState();
}

class _BudgetCalculState extends State<BudgetCalcul> {
  double salaire = 2500;
  double depenses = 1500;

  double get epargne => salaire - depenses;
  double get pouvoirAchat2029 => salaire * 0.923;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Salaire : ${salaire.toInt()} €", style: const TextStyle(color: Colors.white, fontSize: 18)),
          Slider(value: salaire, min: 1000, max: 10000, activeColor: const Color(0xFF00E5FF), onChanged: (v) => setState(() => salaire = v)),
          const SizedBox(height: 16),
          Text("Dépenses : ${depenses.toInt()} €", style: const TextStyle(color: Colors.white, fontSize: 18)),
          Slider(value: depenses, min: 500, max: 5000, activeColor: const Color(0xFF00E5FF), onChanged: (v) => setState(() => depenses = v)),
          const SizedBox(height: 32),
          Text("Reste à vivre : ${epargne.toInt()} €", style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Pouvoir d'achat 2029 : ${pouvoirAchat2029.toInt()} €", style: const TextStyle(color: Colors.orangeAccent, fontSize: 18)),
        ],
      ),
    );
  }
}
