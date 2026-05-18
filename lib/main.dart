import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: VipFit(), debugShowCheckedModeBanner: false
));

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
    if (type == 'Malbouffe') return "Alerte gras ! Légumes verts requis et doublez votre volume d'eau.";
    if (obj == 'Muscle') {
      if (moment == 'Matin') return "4 Œufs, Flocons d'avoine, 1 Banane";
      if (moment == 'Midi') return "Poulet grillé, Riz complet, Huile d'olive";
      return "Saumon, Patates douces, Brocolis";
    } else {
      if (moment == 'Matin') return "Fromage blanc 0%, Amandes";
      if (moment == 'Midi') return "Steak haché 5%, Quinoa, Courgettes";
      return "Salade de thon, Avocat, Tomates";
    }
  }

  // Sélecteur Premium ultra-léger fait main
  Widget _buildTile(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1000FF66) : const Color(0xFF111622),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF00FF66) : Colors.transparent, width: 1.5),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? const Color(0xFF00FF66) : Colors.whiteb70, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xFF00FF66);
    const cardBg = Color(0xFF111622);
    const head = TextStyle(fontSize: 28, fontWeight: FontWeight.black, color: Colors.white, letterSpacing: -0.5);
    const val = TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: neon, letterSpacing: -2);

    return Scaffold(
      backgroundColor: const Color(0xFF070A10),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LinearProgressIndicator(value: (step + 1) / 6, backgroundColor: cardBg, color: neon, minHeight: 4),
          const SizedBox(height: 40),
          if (step == 0) ...[
            const Text("VOTRE GENRE", style: head),
            const SizedBox(height: 24),
            _buildTile("Homme", sex == 'Homme', () => setState(() => sex = 'Homme')),
            _buildTile("Femme", sex == 'Femme', () => setState(() => sex = 'Femme')),
          ],
          if (step == 1) ...[const Text("VOTRE ÂGE", style: head), Text("$age ans", style: val), Slider(value: age.toDouble(), min: 16, max: 80, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => age = v.toInt()))],
          if (step == 2) ...[const Text("VOTRE POIDS", style: head), Text("$pds kg", style: val), Slider(value: pds.toDouble(), min: 40, max: 150, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => pds = v.toInt()))],
          if (step == 3) ...[const Text("VOTRE TAILLE", style: head), Text("$tll cm", style: val), Slider(value: tll.toDouble(), min: 140, max: 220, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => tll = v.toInt()))],
          if (step == 4) ...[
            const Text("VOTRE OBJECTIF", style: head),
            const SizedBox(height: 24),
            _buildTile("Prise de muscle", obj == 'Muscle', () => setState(() => obj = 'Muscle')),
            _buildTile("Perte de gras", obj == 'Perte de gras', () => setState(() => obj = 'Perte de gras')),
          ],
          if (step == 5) ...[const Text("MASSE À BÂTIR", style: head), Text("+$kgMuscle kg", style: val), Slider(value: kgMuscle.toDouble(), min: 1, max: 25, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => kgMuscle = v.toInt()))],
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() => step++),
            child: Container(
              width: double.infinity, height: 54,
              decoration: BoxDecoration(color: neon, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(step == 5 ? "GÉNÉRER LE PLAN" : "CONTINUER", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.black, fontSize: 16)),
            ),
          )
        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tab == 0 ? "TRACKER" : "DIÈTE PREMIUM", style: head),
            GestureDetector(onTap: () => setState(() { step = tab = 0; eauLitre = 0; matin = midi = soir = 'Sain'; }), child: const Text("Reset", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)))
          ]),
          const SizedBox(height: 24),
          Expanded(child: SingleChildScrollView(child: tab == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("EAU ABSORBÉE", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
            Text("${eauLitre.toStringAsFixed(1)} L", style: val),
            Slider(value: eauLitre, min: 0.0, max: 6.0, activeColor: Colors.blueAccent, inactiveColor: cardBg, onChanged: (v) => setState(() => eauLitre = v)),
            const SizedBox(height: 20),
            const Text("RESTE À BOIRE", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
            Text("${eauRestante.toStringAsFixed(1)} L", style: TextStyle(fontSize: 38, fontWeight: FontWeight.black, color: eauRestante == 0 ? neon : Colors.orange)),
            const SizedBox(height: 32),
            const Text("QUALITÉ DES REPAS", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 12),
            ...[
              {'l': 'Matin', 'v': matin, 'c': (s) => setState(() => matin = s)},
              {'l': 'Midi', 'v': midi, 'c': (s) => setState(() => midi = s)},
              {'l': 'Soir', 'v': soir, 'c': (s) => setState(() => soir = s)},
            ].map((r) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(r['l'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Row(children: ['Sain', 'Malbouffe'].map((t) => GestureDetector(
                onTap: () => (r['c'] as Function(String))(t),
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: r['v'] == t ? (t == 'Sain' ? neon : Colors.orange) : cardBg, borderRadius: BorderRadius.circular(8)),
                  child: Text(t, style: TextStyle(color: r['v'] == t ? Colors.black : Colors.white38, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              )).toList())
            ])))
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("OBJECTIF : +$kgMuscle KG ($obj)", style: const TextStyle(fontSize: 13, color: neon, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$calCible kcal / jour", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.black)),
              ]),
            ),
            const SizedBox(height: 24),
            ...['Matin', 'Midi', 'Soir'].map((m) => Container(
              width: double.infinity, margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(m.toUpperCase(), style: const TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 6),
                Text(getRepas(m, m == 'Matin' ? matin : (m == 'Midi' ? midi : soir)), style: const TextStyle(color: Colors.whiteEF, fontSize: 15, height: 1.3)),
              ]),
            )).toList(),
          ]))),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            GestureDetector(onTap: () => setState(() => tab = 0), child: Text("SUIVI", style: TextStyle(color: tab == 0 ? neon : Colors.white24, fontWeight: FontWeight.black, fontSize: 15))),
            GestureDetector(onTap: () => setState(() => tab = 1), child: Text("REPAS", style: TextStyle(color: tab == 1 ? neon : Colors.white24, fontWeight: FontWeight.black, fontSize: 15))),
          ])
        ]),
      )),
    );
  }
}
