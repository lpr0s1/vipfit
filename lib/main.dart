import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: VipFit(), debugShowCheckedModeBanner: false));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int step = 0, tab = 0, age = 22, pds = 70, tll = 175, kgMuscle = 5;
  double eauLitre = 0.0;
  String sex = 'Homme', obj = 'Muscle', matin = 'Sain', midi = 'Sain', soir = 'Sain';

  int get calCible => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (kgMuscle * 150)).toInt();
  double get eauCible => (pds * 0.035) + (sex == 'Homme' ? 0.5 : 0);
  double get eauRestante => (eauCible - eauLitre) < 0 ? 0.0 : (eauCible - eauLitre);

  String getRepas(String moment, String type) {
    if (type == 'Malbouffe') return "Alerte gras ! Legumes verts requis et doublez l eau.";
    if (obj == 'Muscle') {
      if (moment == 'Matin') return "4 Oeufs, Flocons d avoine, 1 Banane";
      if (moment == 'Midi') return "Poulet grille, Riz complet, Huile d olive";
      return "Saumon, Patates douces, Brocolis";
    } else {
      if (moment == 'Matin') return "Fromage blanc 0 pourcent, Amandes";
      if (moment == 'Midi') return "Steak hache 5 pourcent, Quinoa, Courgettes";
      return "Salade de thon, Avocat, Tomates";
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color neon = Color(0xFF00FF66);
    const TextStyle head = TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: neon, letterSpacing: -1);
    const TextStyle value = TextStyle(fontSize: 50, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2);
    const TextStyle labelStyle = TextStyle(fontSize: 14, color: Colors.white38, fontWeight: FontWeight.bold);

    return Scaffold(
      backgroundColor: const Color(0xFF05070B),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LinearProgressIndicator(value: (step + 1) / 6, backgroundColor: Colors.white10, color: neon),
          const SizedBox(height: 50),
          if (step == 0) ...[
            const Text("VOTRE GENRE", style: head),
            const SizedBox(height: 20),
            ...['Homme', 'Femme'].map((s) => TextButton(onPressed: () => setState(() => sex = s), child: Row(children: [Text(s, style: TextStyle(fontSize: 22, color: sex == s ? neon : Colors.white54, fontWeight: FontWeight.bold))]))),
          ],
          if (step == 1) ...[Text("VOTRE AGE", style: head), Text("$age ans", style: value), Slider(value: age.toDouble(), min: 16, max: 80, activeColor: neon, onChanged: (v) => setState(() => age = v.toInt()))],
          if (step == 2) ...[Text("VOTRE POIDS", style: head), Text("$pds kg", style: value), Slider(value: pds.toDouble(), min: 40, max: 150, activeColor: neon, onChanged: (v) => setState(() => pds = v.toInt()))],
          if (step == 3) ...[Text("VOTRE TAILLE", style: head), Text("$tll cm", style: value), Slider(value: tll.toDouble(), min: 140, max: 220, activeColor: neon, onChanged: (v) => setState(() => tll = v.toInt()))],
          if (step == 4) ...[
            const Text("OBJECTIF CIBLE", style: head),
            const SizedBox(height: 20),
            ...['Muscle', 'Perte de gras'].map((o) => TextButton(onPressed: () => setState(() => obj = o), child: Row(children: [Text(o, style: TextStyle(fontSize: 22, color: obj == o ? neon : Colors.white54, fontWeight: FontWeight.bold))]))),
          ],
          if (step == 5) ...[Text("MASSE A BÂTIR", style: head), Text("+$kgMuscle kg", style: value), Slider(value: kgMuscle.toDouble(), min: 1, max: 25, activeColor: neon, onChanged: (v) => setState(() => kgMuscle = v.toInt()))],
          const Spacer(),
          TextButton(style: TextButton.styleFrom(backgroundColor: neon, minimumSize: const Size(double.infinity, 56)), onPressed: () => setState(() => step++), child: Text(step == 5 ? "GENERER MON PLAN" : "CONTINUER", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16))),
        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tab == 0 ? "HYDRATATION" : "NUTRITION", style: head),
            TextButton(onPressed: () => setState(() { step = 0; tab = 0; eauLitre = 0; matin = 'Sain'; midi = 'Sain'; soir = 'Sain'; }), child: const Text("Reset", style: TextStyle(color: Colors.white24)))
          ]),
          const SizedBox(height: 30),
          Expanded(child: SingleChildScrollView(child: tab == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("VOLUME ABSORBE", style: labelStyle),
            Text("${eauLitre.toStringAsFixed(1)} L", style: value),
            Slider(value: eauLitre, min: 0.0, max: 6.0, activeColor: Colors.blueAccent, onChanged: (v) => setState(() => eauLitre = v)),
            const SizedBox(height: 30),
            const Text("QUOTA ENCORE REQUIS", style: labelStyle),
            Text("${eauRestante.toStringAsFixed(1)} L", style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: eauRestante == 0 ? neon : Colors.orange)),
            const SizedBox(height: 30),
            ...[
              {'l': 'Matin', 'v': matin, 'c': (s) => setState(() => matin = s)},
              {'l': 'Midi', 'v': midi, 'c': (s) => setState(() => midi = s)},
              {'l': 'Soir', 'v': soir, 'c': (s) => setState(() => soir = s)},
            ].map((r) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(r['l'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Row(children: ['Sain', 'Malbouffe'].map((t) => TextButton(onPressed: () => (r['c'] as Function(String))(t), child: Text(t, style: TextStyle(color: r['v'] == t ? (t == 'Sain' ? neon : Colors.orange) : Colors.white24, fontWeight: FontWeight.bold)))).toList())
            ])))
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("OBJECTIF : +$kgMuscle KG ($obj)", style: const TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            Text("Budget : $calCible kcal / jour", style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ...['Matin', 'Midi', 'Soir'].map((m) => Padding(padding: const EdgeInsets.only(bottom: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(m.toUpperCase(), style: const TextStyle(color: neon, fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(getRepas(m, m == 'Matin' ? matin : (m == 'Midi' ? midi : soir)), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
            ])))
          ]))),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton(onPressed: () => setState(() => tab = 0), child: Text("SUIVI", style: TextStyle(color: tab == 0 ? neon : Colors.white24, fontWeight: FontWeight.bold, fontSize: 16))),
            TextButton(onPressed: () => setState(() => tab = 1), child: Text("PLAN", style: TextStyle(color: tab == 1 ? neon : Colors.white24, fontWeight: FontWeight.bold, fontSize: 16))),
          ])
        ]),
      )),
    );
  }
}
