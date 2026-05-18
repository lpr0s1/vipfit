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
  double get eauRest => ((pds * 0.035) + (sex == 'Homme' ? 0.5 : 0) - eau) < 0 ? 0.0 : ((pds * 0.035) + (sex == 'Homme' ? 0.5 : 0) - eau);

  String rep(String m, String t) {
    if (t == 'Malbouffe') return "Alerte gras ! Legumes requis et doublez l eau.";
    if (obj == 'Muscle') return m == 'Matin' ? "4 Oeufs, Avoine, Banane" : m == 'Midi' ? "Poulet, Riz, Huile" : "Saumon, Patates douces, Brocolis";
    return m == 'Matin' ? "Fromage blanc 0%, Amandes" : m == 'Midi' ? "Steak hache 5%, Quinoa" : "Salade de thon, Avocat, Tomates";
  }

  Widget btn(String t, bool act, VoidCallback f) => GestureDetector(onTap: f, child: Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(t, style: TextStyle(fontSize: 22, color: act ? const Color(0xFF00FF66) : Colors.white38, fontWeight: FontWeight.bold))));
  Widget sld(double v, double min, double max, Function(double) f) => Slider(value: v, min: min, max: max, activeColor: const Color(0xFF00FF66), onChanged: f);

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xFF00FF66);
    const head = TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: neon, letterSpacing: -1);
    const val = TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2);

    return Scaffold(
      backgroundColor: const Color(0xFF05070B),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("ÉTAPE ${step + 1} / 6", style: const TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        if (step == 0) ...[const Text("GENRE", style: head), btn("Homme", sex == 'Homme', () => setState(() => sex = 'Homme')), btn("Femme", sex == 'Femme', () => setState(() => sex = 'Femme'))],
        if (step == 1) ...[const Text("AGE", style: head), Text("$age ans", style: val), sld(age.toDouble(), 16, 80, (v) => setState(() => age = v.toInt()))],
        if (step == 2) ...[const Text("POIDS", style: head), Text("$pds kg", style: val), sld(pds.toDouble(), 40, 150, (v) => setState(() => pds = v.toInt()))],
        if (step == 3) ...[const Text("TAILLE", style: head), Text("$tll cm", style: val), sld(tll.toDouble(), 140, 220, (v) => setState(() => tll = v.toInt()))],
        if (step == 4) ...[const Text("OBJECTIF", style: head), btn("Muscle", obj == 'Muscle', () => setState(() => obj = 'Muscle')), btn("Perte de gras", obj == 'Perte', () => setState(() => obj = 'Perte'))],
        if (step == 5) ...[const Text("MASSE CIBLE", style: head), Text("+$kg kg", style: val), sld(kg.toDouble(), 1, 25, (v) => setState(() => kg = v.toInt()))],
        const Spacer(),
        GestureDetector(onTap: () => setState(() => step++), child: Container(width: double.infinity, padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: neon, borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Text(step == 5 ? "GO" : "SUITE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18))))
      ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(tab == 0 ? "HYDRATATION" : "NUTRITION", style: head), GestureDetector(onTap: () => setState(() { step = tab = 0; eau = 0; matin = midi = soir = 'Sain'; }), child: const Text("Reset", style: TextStyle(color: Colors.white24)))]),
        const SizedBox(height: 30),
        Expanded(child: tab == 0 ? ListView(children: [
          const Text("ABSORBÉ", style: TextStyle(color: Colors.white38)), Text("${eau.toStringAsFixed(1)} L", style: val),
          sld(eau, 0.0, 6.0, (v) => setState(() => eau = v)),
          const SizedBox(height: 30),
          const Text("REQUIS", style: TextStyle(color: Colors.white38)), Text("${eauRest.toStringAsFixed(1)} L", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: eauRest == 0 ? neon : Colors.orange)),
          const SizedBox(height: 40),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Matin", style: TextStyle(color: Colors.white, fontSize: 18)), Row(children: [btn("Sain", matin == 'Sain', () => setState(() => matin = 'Sain')), const SizedBox(width: 20), btn("Gras", matin == 'Malbouffe', () => setState(() => matin = 'Malbouffe'))])]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Midi", style: TextStyle(color: Colors.white, fontSize: 18)), Row(children: [btn("Sain", midi == 'Sain', () => setState(() => midi = 'Sain')), const SizedBox(width: 20), btn("Gras", midi == 'Malbouffe', () => setState(() => midi = 'Malbouffe'))])]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("Soir", style: TextStyle(color: Colors.white, fontSize: 18)), Row(children: [btn("Sain", soir == 'Sain', () => setState(() => soir = 'Sain')), const SizedBox(width: 20), btn("Gras", soir == 'Malbouffe', () => setState(() => soir = 'Malbouffe'))])]),
        ]) : ListView(children: [
          Text("OBJECTIF : +$kg KG", style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18)),
          Text("Budget : $cal kcal / jour", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          Text("MATIN", style: TextStyle(color: neon, fontWeight: FontWeight.bold)), Text(rep('Matin', matin), style: const TextStyle(color: Colors.white, fontSize: 18)), const SizedBox(height: 20),
          Text("MIDI", style: TextStyle(color: neon, fontWeight: FontWeight.bold)), Text(rep('Midi', midi), style: const TextStyle(color: Colors.white, fontSize: 18)), const SizedBox(height: 20),
          Text("SOIR", style: TextStyle(color: neon, fontWeight: FontWeight.bold)), Text(rep('Soir', soir), style: const TextStyle(color: Colors.white, fontSize: 18)),
        ])),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [btn("SUIVI", tab == 0, () => setState(() => tab = 0)), btn("PLAN", tab == 1, () => setState(() => tab = 1))])
      ]))),
    );
  }
}
