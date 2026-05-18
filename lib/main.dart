import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: BudgetNavigation())));

class BudgetNavigation extends StatefulWidget {
  const BudgetNavigation({super.key});
  @override
  State<BudgetNavigation> createState() => _BudgetNavigationState();
}

class _BudgetNavigationState extends State<BudgetNavigation> {
  int step = 0;
  double salaire = 2500;
  double depenses = 1500;

  double get epargne => salaire - depenses;
  double get pouvoirAchat2029 => salaire * 0.923;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Titre changeant selon l'étape
            Text(
              step == 0 ? "Étape 1 : Vos Finances" : "Étape 2 : Vos Projections",
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // Contenu dynamique
            Expanded(
              child: SingleChildScrollView(
                child: step == 0
                    ? Column(
                        children: [
                          Text("Salaire : ${salaire.toInt()} €", style: const TextStyle(color: Colors.white)),
                          Slider(value: salaire, min: 1000, max: 10000, activeColor: const Color(0xFF00E5FF), onChanged: (v) => setState(() => salaire = v)),
                          const SizedBox(height: 16),
                          Text("Dépenses : ${depenses.toInt()} €", style: const TextStyle(color: Colors.white)),
                          Slider(value: depenses, min: 500, max: 5000, activeColor: const Color(0xFF00E5FF), onChanged: (v) => setState(() => depenses = v)),
                        ],
                      )
                    : Column(
                        children: [
                          Text("Reste à vivre : ${epargne.toInt()} €", style: const TextStyle(color: Color(0xFF00E5FF), fontSize: 22)),
                          const SizedBox(height: 16),
                          Text("Pouvoir d'achat 2029 : ${pouvoirAchat2029.toInt()} €", style: const TextStyle(color: Colors.orangeAccent, fontSize: 18)),
                        ],
                      ),
              ),
            ),
            
            // Bouton d'action pour basculer d'étape
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E5FF), minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => step = step == 0 ? 1 : 0),
              child: Text(step == 0 ? "SUIVANT" : "RETOUR", style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
