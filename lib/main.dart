import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(brightness: Brightness.dark, useMaterial3: true, colorSchemeSeed: const Color(0xFF00FF66)),
  home: const VipFit(), debugShowCheckedModeBanner: false
));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int step = 0, tab = 0, age = 22, pds = 70, tll = 175, calPris = 0, eauPrise = 0;
  String sex = 'Homme', obj = 'Full body';

  int get calCible => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (obj != 'Full body' ? 400 : 0)).toInt();
  int get eauCible => (pds * 35) + (sex == 'Homme' ? 500 : 0);

  String get nutrition => pds > 80 ? "Déficit calorique. Moins de glucides, ratio 40/30/30." : "Prise de muscle. 2g de protéines/kg de poids.";
  String get sport => obj == 'Full body' ? "Circuit HIIT 3x/semaine (Squats, Pompes, Gainage)." : "Focus $obj : 4 séries lourdes, mouvements polyarticulaires.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: step < 5 ? Column(children: [
          LinearProgressIndicator(value: (step + 1) / 5),
          const SizedBox(height: 20),
          if (step == 0) ...[const Text("Sexe"), ...['Homme', 'Femme'].map((s) => RadioListTile(title: Text(s), value: s, groupValue: sex, onChanged: (v) => setState(() => sex = v!)))],
          if (step == 1) ...[Text("Âge : $age ans"), Slider(value: age.toDouble(), min: 16, max: 80, onChanged: (v) => setState(() => age = v.toInt()))],
          if (step == 2) ...[Text("Poids : $pds kg"), Slider(value: pds.toDouble(), min: 40, max: 150, onChanged: (v) => setState(() => pds = v.toInt()))],
          if (step == 3) ...[Text("Taille : $tll cm"), Slider(value: tll.toDouble(), min: 140, max: 220, onChanged: (v) => setState(() => tll = v.toInt()))],
          if (step == 4) ...[const Text("Objectif"), ...['Full body', 'Pectoraux', 'Dos'].map((o) => RadioListTile(title: Text(o), value: o, groupValue: obj, onChanged: (v) => setState(() => obj = v!)))],
          const Spacer(),
          ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), onPressed: () => setState(() => step++), child: Text(step == 4 ? "GÉNÉRER MON PLAN" : "CONTINUER"))
        ]) : Column(children: [
          ListTile(
            title: Text(tab == 0 ? "ÉNERGIE DU JOUR" : "MON PLAN SUR MESURE"),
            trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: () => setState(() { step = 0; tab = 0; calPris = 0; eauPrise = 0; })),
          ),
          Expanded(child: SingleChildScrollView(child: tab == 0 ? Column(children: [
            Card(child: ListTile(leading: const Icon(Icons.local_fire_department, color: Colors.orange), title: const Text("Calories Restantes"), subtitle: Text("${calCible - calPris} kcal / $calCible"))),
            Card(child: ListTile(leading: const Icon(Icons.water_drop, color: Colors.blue), title: const Text("Eau Restante"), subtitle: Text("${eauCible - eauPrise} ml / $eauCible"))),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: FilledButton(onPressed: () => setState(() => calPris += 350), child: const Text("+350 kcal"))),
              const SizedBox(width: 10),
              Expanded(child: FilledButton(onPressed: () => setState(() => eauPrise += 500), child: const Text("+500 ml"))),
            ]),
          ]) : Column(children: [
            Card(child: ListTile(leading: const Icon(Icons.restaurant), title: const Text("Alimentation conseillée"), subtitle: Text(nutrition))),
            Card(child: ListTile(leading: const Icon(Icons.fitness_center), title: const Text("Entraînement conseillé"), subtitle: Text(sport))),
            Card(child: ListTile(leading: const Icon(Icons.person), title: const Text("Profil enregistré"), subtitle: Text("$sex • $age ans • $pds kg • $tll cm"))),
          ]))),
          NavigationBar(
            selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [NavigationDestination(icon: Icon(Icons.bolt), label: "Suivi"), NavigationDestination(icon: Icon(Icons.assignment), label: "Plan")],
          )
        ]),
      )),
    );
  }
}
