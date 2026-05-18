import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: VipFit(), debugShowCheckedModeBanner: false));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int step = 0, tab = 0, age = 22, pds = 70, tll = 175, kg = 5;
  double eau = 0.0;
  String sex = 'Homme', obj = 'Muscle', matin = 'Sain', midi = 'Sain', soir = 'Sain';

  int get cal => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (kg * 150)).toInt();
  double get eauRest => ((pds * 0.035) + (sex == 'Homme' ? 0.5 : 0) - eau).clamp(0.0, 9.0);

  String rep(String m, String t) {
    if (t == 'Malbouffe') return "Alerte gras ! Legumes requis et doublez l eau.";
    return obj == 'Muscle' 
      ? (m == 'Matin' ? "4 Oeufs, Avoine, Banane" : m == 'Midi' ? "Poulet, Riz, Huile" : "Saumon, Patates douces")
      : (m == 'Matin' ? "Fromage blanc 0%, Amandes" : m == 'Midi' ? "Steak 5%, Quinoa" : "Salade thon, Avocat");
  }

  Widget btn(String t, bool act, VoidCallback f) => GestureDetector(
    onTap: f, 
    child: Text(t, style: TextStyle(fontSize: 20, color: act ? const Color(0xFF00FF66) : Colors.white38, fontWeight: FontWeight.bold))
  );

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xFF00FF66);
    const head = TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: neon, letterSpacing: -1);
    const val = TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2);

    return Scaffold(
      backgroundColor: const Color(0xFF05070B),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("ÉTAPES", style: TextStyle(color: neon.withOpacity(0.3), fontWeight: FontWeight.bold, letterSpacing: 2)),
        const SizedBox(height: 30),
        if (step == 0) ...[const Text("GENRE", style: head), const SizedBox(height: 20), btn("Homme", sex == 'Homme', () => setState(() => sex = 'Homme')), const SizedBox(height: 10), btn("Femme", sex == 'Femme', () => setState(() => sex = 'Femme'))],
        if (step == 1) ...[const Text("AGE", style: head), Text("$age ans", style: val), Slider(value: age.toDouble(), min: 16, max: 80, activeColor: neon, onChanged: (v) => setState(() => age = v.toInt()))],
        if (step == 2) ...[const Text("POIDS", style: head), Text("$pds kg", style: val), Slider(value: pds.toDouble(), min: 40, max: 150, activeColor: neon, onChanged: (v) => setState(() => pds = v.toInt()))],
        if (step == 3) ...[const Text("TAILLE", style: head), Text("$tll cm", style: val), Slider(value: tll.toDouble(), min: 140, max: 220, activeColor: neon, onChanged: (v) => setState(() => tll = v.toInt()))],
        if (step == 4) ...[const Text("OBJECTIF", style: head), const SizedBox(height: 20), btn("Muscle", obj == 'Muscle', () => setState(() => obj = 'Muscle')), const SizedBox(height: 10), btn("Perte de gras", obj == 'Perte', () => setState(() => obj = 'Perte'))],
        if (step == 5) ...[const Text("MASSE CIBLE", style: head), Text("+$kg kg", style: val), Slider(value: kg.toDouble(), min: 1, max: 25, activeColor: neon, onChanged: (v) => setState(() => kg = v.toInt()))],
        const Spacer(),
        GestureDetector(onTap: () => setState(() => step++), child: Container(width: double.infinity, padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: neon, borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text("CONTINUER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.black, fontSize: 16))))
      ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tab == 0 ? "SUIVI" : "DIÈTE", style: head), GestureDetector(onTap: () => setState(() { step = tab = 0; eau = 0; matin = midi = soir = 'Sain'; }), child: const Text("Reset", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)))]),
        const SizedBox(height: 30),
        Expanded(child: tab == 0 ? ListView(children: [
          const Text("EAU ABSORBÉE", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)), Text("${eau.toStringAsFixed(1)} L", style: val),
          Slider(value: eau, min: 0.0, max: 6.0, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => eau = v)),
          const SizedBox(height: 20),
          const Text("RESTE À BOIRE", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold)), Text("${eauRest.toStringAsFixed(1)} L", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: eauRest == 0 ? neon : Colors.orange)),
          const SizedBox(height: 30),
          ...[
            {'l': 'Matin', 'v': matin, 'c': (s) => setState(() => matin = s)},
            {'l': 'Midi', 'v': midi, 'c': (s) => setState(() => midi = s)},
            {'l': 'Soir', 'v': soir, 'c': (s) => setState(() => soir = s)},
          ].map((r) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(r['l'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Row(children: [btn("Sain", r['v'] == 'Sain', () => (r['c'] as Function(String))('Sain')), const SizedBox(width: 15), btn("Gras", r['v'] == 'Malbouffe', () => (r['c'] as Function(String))('Malbouffe'))])
          ])))
        ]) : ListView(children: [
          Text("OBJECTIF : +$kg KG ($obj)", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.black)),
          Text("$cal kcal / jour", style: val),
          const SizedBox(height: 30),
          ...['Matin', 'Midi', 'Soir'].map((m) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(m.toUpperCase(), style: const TextStyle(color: neon, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(rep(m, m == 'Matin' ? matin : (m == 'Midi' ? midi : soir)), style: const TextStyle(color: Colors.white, fontSize: 16)),
          ])))
        ])),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btn("L'EAU", tab == 0, () => setState(() => tab = 0)), btn("REPAS", tab == 1, () => setState(() => tab = 1))])
      ]))),
    );
  }
}
