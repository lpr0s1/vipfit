import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: BudgetExpress())));

class BudgetExpress extends StatefulWidget {
  const BudgetExpress({super.key});
  @override
  State<BudgetExpress> createState() => _BudgetExpressState();
}

class _BudgetExpressState extends State<BudgetExpress> {
  final int salaire = 2500;
  final int depenses = 1500;
  int get resteAVivre => salaire - depenses;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Salaire: $salaire €', style: const TextStyle(fontSize: 20)),
          Text('Dépenses: $depenses €', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),
          Text('Reste à vivre: $resteAVivre €', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.cyan)),
        ],
      ),
    );
  }
}
