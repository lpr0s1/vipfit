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

  // Widget d'aide (Popup élégante)
  void _showDetail(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.6)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(children: [
      Padding(padding: const EdgeInsets.all(25), child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/app_icon.png', width: 45, height: 45)),
        const SizedBox(width: 15),
        const Text("VIP FIT ELITE", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900))
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

  // --- NOUVEAUX SELECTEURS INTUITIFS ---
  Widget _getStepContent() {
    final steps = [
      _field("Sexe", _chips(["Homme", "Femme"], sexe, (v) => setState(() => sexe = v))),
      _field("Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Poids (${poids < 65 ? 'Léger' : 'Lourd'})", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Taille (${taille < 170 ? 'Petit' : 'Grand'})", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Réveil", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau (L/jour)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Structure", _chips(["Fine", "Normale"], ossature, (v) => setState(() => ossature = v))),
      _field("Priorité", _chips(["Bras", "Jambes", "Dos"], focus, (v) => setState(() => focus = v))),
    ];
    return steps[etape];
  }

  // --- SÉLECTEURS TACTILES (CHIPS) ---
  Widget _chips(List<String> items, String current, Function(String) f) => Wrap(spacing: 15, children: items.map((e) => ChoiceChip(
    label: Text(e, style: TextStyle(fontSize: 18, color: current == e ? Colors.black : Colors.white)),
    selected: current == e,
    onSelected: (_) => f(e),
    selectedColor: Colors.amber,
    backgroundColor: const Color(0xFF1C1C1E),
  )).toList());

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

  // --- RÉSULTATS ---
  Widget _buildResults() => ListView(padding: const EdgeInsets.all(25), children: [
    _section("NUTRITION CIBLÉE", [
      _actionTile("Besoin Hydrique", "${(poids * 0.035).toStringAsFixed(1)}L"),
      _actionTile("Ratio Noix", "${(poids * 0.4).toInt()}g"),
    ]),
  ]);

  Widget _section(String title, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 25),
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.1), blurRadius: 10)]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
      const SizedBox(height: 15),
      ...children
    ]),
  );

  Widget _actionTile(String t, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(t, style: const TextStyle(color: Colors.white, fontSize: 18)),
    Text(v, style: const TextStyle(color: Colors.white30, fontSize: 18, fontWeight: FontWeight.bold))
  ]));
}