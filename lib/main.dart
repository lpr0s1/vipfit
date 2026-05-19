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
  
  // Données de base
  String sexe = "Homme", ossature = "Fine", focus = "Bras";
  int age = 20, poids = 75, taille = 180, reveil = 8, eauActuelle = 2;

  // Popup de détail
  void _showDetail(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        height: 300,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: Colors.amber, fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 18, height: 1.5)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(children: [
      Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/app_icon.png', width: 35, height: 35)),
        const SizedBox(width: 12),
        const Text("VIP FIT", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))
      ])),
      Expanded(child: showResults ? _buildResults() : _buildStepper()),
    ]));
  }

  Widget _buildStepper() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(children: [
      _getStepContent(),
      const Spacer(),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => setState(() => etape < 7 ? etape++ : showResults = true),
        child: Text(etape == 7 ? "GÉNÉRER MON PROTOCOLE" : "Continuer"),
      ),
      const SizedBox(height: 24)
    ]));
  }

  Widget _getStepContent() {
    final steps = [
      _field("Sexe", _dropdown(["Homme", "Femme", "Arbre"], sexe, (v) => setState(() => sexe = v!))),
      _field("Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Poids (${poids < 65 ? 'Léger' : 'Lourd'})", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Taille (${taille < 170 ? 'Petit' : 'Grand'})", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Heure de lever", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau consommée (L)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Structure", _dropdown(["Fine", "Normale"], ossature, (v) => setState(() => ossature = v!))),
      _field("Zone prioritaire", _dropdown(["Bras", "Jambes", "Dos"], focus, (v) => setState(() => focus = v!))),
    ];
    return steps[etape];
  }

  Widget _buildResults() {
    double besoinsEau = poids * 0.035;
    return ListView(padding: const EdgeInsets.all(20), children: [
      _section("NUTRITION CIBLÉE", [
        _actionTile("Besoin Hydrique", "${besoinsEau.toStringAsFixed(1)}L / jour", "Boire ${((besoinsEau - eauActuelle).clamp(0, 10)).toStringAsFixed(1)}L de plus pour maximiser la synthèse protéique."),
        _actionTile("Ratio Noix/Articulations", "${(poids * 0.4).toInt()}g", "Riche en Oméga-3. Indispensable pour la lubrification tendineuse."),
        _actionTile("Congestion Pistaches", "${(poids * 0.5).toInt()}g", "Vasodilatateur naturel (L-Arginine) à prendre 30min avant l'effort."),
      ]),
      const SizedBox(height: 20),
      _section("PROTOCOL SPORTIF", [
        _actionTile("Temps de repos", ossature == "Fine" ? "120 sec (Sécurisé)" : "90 sec", "Le repos allongé protège tes articulations fines de la surcharge."),
        _actionTile("Exo Prioritaire", "Farmer Walk", "L'exercice roi pour épaissir tes avant-bras."),
        _actionTile("Volume $focus", "4 séries x 12 reps", "Intensité élevée pour forcer le recrutement des fibres musculaires."),
      ]),
    ]);
  }

  Widget _section(String title, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ...children
    ]),
  );

  Widget _actionTile(String title, String val, String detail) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: const TextStyle(color: Colors.white)),
    trailing: Row(mainAxisSize: MainAxisSize.min, children: [Text(val, style: const TextStyle(color: Colors.white30)), const Icon(Icons.info_outline, color: Colors.amber, size: 25)]),
    onTap: () => _showDetail(title, detail),
  );

  Widget _field(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white54, fontSize: 30)), const SizedBox(height: 12), child]);
  Widget _ctrl(int v, Function(int) f) => Row(children: [IconButton(onPressed: () => f(v-1), icon: const Icon(Icons.remove_circle, color: Colors.white)), Text("$v", style: const TextStyle(color: Colors.white, fontSize: 50)), IconButton(onPressed: () => f(v+1), icon: const Icon(Icons.add_circle, color: Colors.white))]);
  Widget _dropdown(List<String> items, String val, Function(String?) f) => DropdownButton<String>(value: val, dropdownColor: Colors.black, items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: f, isExpanded: true);
}