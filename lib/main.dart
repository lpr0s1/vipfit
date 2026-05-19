import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/vxshare5/249');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(children: [
      Padding(padding: const EdgeInsets.all(25), child: Row(children: [
        if (etape > 0 && !showResults) IconButton(onPressed: () => setState(() => etape--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/app_icon.png', width: 40, height: 40)),
        const SizedBox(width: 15),
        const Text("VIP FIT", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        const Spacer(),
        PopupMenuButton<String>(
          icon: const Icon(Icons.help_outline, color: Colors.amber, size: 30),
          color: const Color(0xFF1C1C1E),
          onSelected: (value) => _launchTelegram(),
          itemBuilder: (context) => [const PopupMenuItem(value: "help", child: Text("Help - Telegram", style: TextStyle(color: Colors.white)))],
        )
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
        child: Text(etape == 7 ? "GÉNÉRER MON PLAN" : "CONTINUER", style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
      )),
      const SizedBox(height: 30)
    ]));
  }

  Widget _buildResults() => ListView(padding: const EdgeInsets.all(25), children: [
    const Text("VOTRE PLAN", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
    const SizedBox(height: 20),
    _sectionIntuitive("NUTRITION CIBLÉE", Icons.restaurant_menu, [
      _infoBouton("Vous avez besoin d'eau: ", "${( (poids*0.035) - eauActuelle).clamp(0, 5).toStringAsFixed(1)}L"),
      _infoBouton("Ratio Noix", "${(poids * 0.4).toInt()}g"),
    ]),
    _sectionIntuitive("PROTOCOLE SPORTIF ($focus)", Icons.fitness_center, [
      _infoBouton("Repos entre séries", ossature == "Fine" ? "120 secondes" : "90 secondes"),
      _infoBouton("Exercice Clé", "Farmer Walk"),
    ]),
    const SizedBox(height: 20),
    Center(child: TextButton(onPressed: () => setState(() {showResults = false; etape = 7;}), child: const Text("Modifier mes infos", style: TextStyle(color: Colors.white30))))
  ]);

  Widget _sectionIntuitive(String title, IconData icon, List<Widget> children) => ExpansionTile(
    leading: Icon(icon, color: Colors.amber),
    title: Text(title, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
    backgroundColor: const Color(0xFF1C1C1E),
    collapsedBackgroundColor: const Color(0xFF1C1C1E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    childrenPadding: const EdgeInsets.all(15),
    children: children,
  );

  Widget _infoBouton(String label, String value) => Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(15)),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.white70)),
      Text(value, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _getStepContent() {
    final steps = [
      _field("Ton Sexe", _chips(["Homme", "Femme"], sexe, (v) => setState(() => sexe = v))),
      _field("Ton Âge", _ctrl(age, (v) => setState(() => age = v))),
      _field("Ton Poids", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Ta Taille", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Réveil", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Eau (L)", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Structure", _chips(["Fine", "Normale"], ossature, (v) => setState(() => ossature = v))),
      _field("Objectif", _chips(["Bras", "Jambes", "Dos"], focus, (v) => setState(() => focus = v))),
    ];
    return steps[etape];
  }

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