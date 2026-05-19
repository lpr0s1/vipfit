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
  int age = 25, poids = 75, taille = 175, reveil = 7, eauActuelle = 2;

  void _showDetail(String title, String content) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(content, style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFFFD700);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/app_icon.png', width: 32, height: 32)),
              const SizedBox(width: 12),
              const Text("VIP FIT", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ]),
          ),
          Expanded(child: showResults ? _buildPlan(gold) : _buildStepper(gold)),
        ],
      ),
    );
  }

  Widget _buildStepper(Color gold) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _getStepContent(),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => setState(() => etape < 7 ? etape++ : showResults = true),
            child: Text(etape == 7 ? "GÉNÉRER MON PLAN" : "Continuer", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _getStepContent() {
    final steps = [
      _field("Sexe", DropdownButton<String>(value: sexe, dropdownColor: Colors.black, items: ["Homme", "Femme"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => sexe = v!))),
      _field("Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Poids (${poids < 65 ? 'Léger' : poids > 85 ? 'Lourd' : 'Moyen'})", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Taille (${taille < 170 ? 'Petit' : taille > 185 ? 'Grand' : 'Moyen'})", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Réveil", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau (L/jour)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Ossature", DropdownButton<String>(value: ossature, dropdownColor: Colors.black, items: ["Fine", "Normale"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => ossature = v!))),
      _field("Objectif", DropdownButton<String>(value: focus, dropdownColor: Colors.black, items: ["Bras", "Jambes", "Dos"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => focus = v!))),
    ];
    return steps[etape];
  }

  Widget _buildPlan(Color gold) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _section("Nutrition", Icons.restaurant_menu, gold, [
          _tile("Calories", "${(poids * 30) + 400} kcal"),
          _actionTile("Besoin en eau", "Ajouter ${((poids * 0.035) - eauActuelle).toStringAsFixed(1)}L", "L'eau permet de transporter les nutriments vers tes muscles."),
          _actionTile("Noix (Articulations)", "${(poids * 0.4).toInt()}g", "Riche en oméga-3 pour tes tendons."),
        ]),
        const SizedBox(height: 20),
        _section("Entraînement", Icons.fitness_center, gold, [
          _tile("Focus", focus),
          _actionTile("Programme $focus", "Voir les exos", "Exercices ciblés pour prendre du volume sur $focus."),
          if (ossature == "Fine") _actionTile("Focus Ossature", "Marche du fermier", "Renforce tes poignets et stabilise tes articulations."),
        ]),
      ],
    );
  }

  Widget _section(String title, IconData icon, Color color, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
    child: Column(children: [
      Row(children: [Icon(icon, color: color), const SizedBox(width: 10), Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
      ...children
    ]),
  );

  Widget _tile(String t, String v) => Padding(padding: const EdgeInsets.only(top: 15), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: const TextStyle(color: Colors.grey)), Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]));
  
  Widget _actionTile(String t, String v, String detail) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: InkWell(
      onTap: () => _showDetail(t, detail),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(t, style: const TextStyle(color: Colors.white)),
        Row(children: [Text(v, style: const TextStyle(color: Colors.grey)), const Icon(Icons.chevron_right, color: Colors.grey)])
      ]),
    ),
  );

  Widget _field(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)), const SizedBox(height: 10), child]);
  Widget _ctrl(int val, Function(int) f) => Row(children: [IconButton(onPressed: () => f(val-1), icon: const Icon(Icons.remove_circle, color: Colors.white)), Text("$val", style: const TextStyle(color: Colors.white, fontSize: 20)), IconButton(onPressed: () => f(val+1), icon: const Icon(Icons.add_circle, color: Colors.white))]);
}