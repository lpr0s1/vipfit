import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipApp())),
  debugShowCheckedModeBanner: false,
));

class VipApp extends StatefulWidget {
  const VipApp({super.key});
  @override
  State<VipApp> createState() => _VipAppState();
}

class _VipAppState extends State<VipApp> {
  int etape = 0;
  bool showResults = false;
  
  String sexe = "Homme", ossature = "Fine", focus = "Bras";
  int age = 20, poids = 75, taille = 180, reveil = 8, eauActuelle = 2;

  String get feedbackMorpho => (poids < 65) 
      ? "Profil Ectomorphe : Priorité à la suralimentation et aux charges lourdes." 
      : "Profil Endomorphe : Priorité à la densité et à l'hydratation constante.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(children: [
      Padding(padding: const EdgeInsets.all(25), child: Row(children: [
        if (etape > 0 && !showResults) IconButton(onPressed: () => setState(() => etape--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/app_icon.png', width: 40, height: 40)),
        const SizedBox(width: 15),
        const Text("VIP FIT ELITE", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))
      ])),
      Expanded(child: showResults ? _buildResults() : _buildStepper()),
    ]));
  }

  Widget _buildStepper() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getStepContent(),
      const Spacer(),
      SizedBox(width: double.infinity, height: 60, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () => setState(() => etape < 7 ? etape++ : showResults = true),
        child: Text(etape == 7 ? "GÉNÉRER MON PROTOCOLE" : "CONTINUER", style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      )),
      const SizedBox(height: 30)
    ]));
  }

  Widget _getStepContent() {
    final steps = [
      _field("Ton Sexe", _chips(["Homme", "Femme", "Arbre"], sexe, (v) => setState(() => sexe = v))),
      _field("Ton Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Ton Poids (${poids < 65 ? 'Léger' : 'Lourd'})", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Ta Taille", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Heure de réveil", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau consommée (L)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Structure Osseuse", _chips(["Fine", "Normale"], ossature, (v) => setState(() => ossature = v))),
      _field("Objectif Prioritaire", _chips(["Bras", "Jambes", "Dos"], focus, (v) => setState(() => focus = v))),
    ];
    return steps[etape];
  }

  Widget _buildResults() => ListView(padding: const EdgeInsets.all(25), children: [
    _section("ANALYSE MORPHOLOGIQUE", [
      _actionTile(Icons.psychology, "Verdict", feedbackMorpho),
      _actionTile(Icons.local_drink, "Hydratation Cible", "Boire ${(poids * 0.035).toStringAsFixed(1)}L/jour. Tu en manques ${((poids*0.035) - eauActuelle).clamp(0, 5).toStringAsFixed(1)}L."),
    ]),
    _section("PROTOCOLE $focus", [
      _actionTile(Icons.fitness_center, "Volume d'entraînement", "4 séries de 12 pour choquer la fibre."),
      _actionTile(Icons.bolt, "Conseil Intensité", ossature == "Fine" ? "Repos 120s pour protéger les tendons." : "Repos 90s pour densifier le muscle."),
    ]),
    const SizedBox(height: 20),
    Center(child: TextButton(onPressed: () => setState(() {showResults = false; etape = 7;}), child: const Text("Modifier mes infos", style: TextStyle(color: Colors.white30))))
  ]);

  Widget _section(String title, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 25),
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(25)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 15),
      ...children
    ]),
  );

  Widget _actionTile(IconData icon, String title, String val) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [
    Icon(icon, color: Colors.amber, size: 28),
    const SizedBox(width: 15),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      Text(val, style: const TextStyle(color: Colors.white30, fontSize: 13))
    ]))
  ]));

  Widget _field(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)), 
    const SizedBox(height: 25), 
    child
  ]);

  Widget _ctrl(int v, Function(int) f) => Row(children: [
    IconButton(onPressed: () => f(v-1), icon: const Icon(Icons.remove_circle, color: Colors.amber, size: 50)), 
    Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Text("$v", style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold))), 
    IconButton(onPressed: () => f(v+1), icon: const Icon(Icons.add_circle, color: Colors.amber, size: 50))
  ]);

  Widget _chips(List<String> items, String current, Function(String) f) => Wrap(spacing: 15, children: items.map((e) => ChoiceChip(
    label: Text(e, style: TextStyle(fontSize: 18, color: current == e ? Colors.black : Colors.white)),
    selected: current == e, onSelected: (_) => f(e), selectedColor: Colors.amber, backgroundColor: const Color(0xFF1C1C1E),
  )).toList());
}