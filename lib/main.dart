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

  String sexe = "Homme";
  int age = 25, poids = 75, taille = 175, reveil = 7, eauActuelle = 2;
  String ossature = "Fine";
  String focus = "Bras";

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFFFD700);
    
    // Calculs
    String stature = (taille < 170) ? "Petit" : (taille > 185) ? "Grand" : "Moyen";
    double eauManquante = ((poids * 0.035) - eauActuelle);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header iOS Style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset('assets/app_icon.png', width: 32, height: 32)),
                const SizedBox(width: 12),
                const Text("VIP FIT", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: showResults ? _buildPlan(gold) : _buildStepper(gold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper(Color gold) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ÉTAPE ${etape + 1} / 8", style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        // Switch selon l'étape
        _getStepContent(etape),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () => setState(() => etape < 7 ? etape++ : showResults = true),
            child: Text(etape == 7 ? "GÉNÉRER MON PLAN" : "Continuer"),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _getStepContent(int step) {
    // Widgets simplifiés pour Xcode
    final List<Widget> steps = [
      _field("Sexe", DropdownButton<String>(value: sexe, dropdownColor: Colors.black, items: ["Homme", "Femme"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => sexe = v!))),
      _field("Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Poids", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Taille", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Réveil", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau (L)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Ossature", DropdownButton<String>(value: ossature, dropdownColor: Colors.black, items: ["Fine", "Normale"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => ossature = v!))),
      _field("Objectif", DropdownButton<String>(value: focus, dropdownColor: Colors.black, items: ["Bras", "Jambes", "Dos"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (v) => setState(() => focus = v!))),
    ];
    return steps[step];
  }

  Widget _field(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)), const SizedBox(height: 10), child]);
  Widget _ctrl(int val, Function(int) f) => Row(children: [IconButton(onPressed: () => f(val-1), icon: const Icon(Icons.remove, color: Colors.white)), Text("$val", style: const TextStyle(color: Colors.white, fontSize: 20)), IconButton(onPressed: () => f(val+1), icon: const Icon(Icons.add, color: Colors.white))]);

  Widget _buildPlan(Color gold) {
    return ListView(
      children: [
        _section("Alimentation", Icons.restaurant_menu, gold, [
          _tile("Calories", "${(poids * 30) + 400} kcal"),
          _tile("Eau", "Boire +${( (poids * 0.035) - eauActuelle ).toStringAsFixed(1)}L"),
        ]),
        const SizedBox(height: 20),
        _section("Entraînement", Icons.fitness_center, gold, [
          _tile("Focus", focus),
          _tile("Morpho", ossature == "Fine" ? "Ossature fragile" : "Standard"),
        ]),
      ],
    );
  }

  Widget _section(String title, IconData icon, Color color, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
    child: Column(children: [Row(children: [Icon(icon, color: color), const SizedBox(width: 10), Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]), ...children]),
  );

  Widget _tile(String title, String val) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(color: Colors.grey)), Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))]),
  );
}