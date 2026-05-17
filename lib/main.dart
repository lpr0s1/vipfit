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
  String sex = 'Homme', obj = 'Muscle';
  String matin = 'Sain', midi = 'Sain', soir = 'Sain';

  int get calCible => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (kgMuscle * 150)).toInt();
  double get eauCible => (pds * 0.035) + (sex == 'Homme' ? 0.5 : 0);
  double get eauRestante => (eauCible - eauLitre) < 0 ? 0.0 : (eauCible - eauLitre);

  String getRepas(String moment, String type) {
    if (type == 'Malbouffe') return "Alerte gras ! Legumes verts et doublez l eau.";
    if (obj == 'Muscle') {
      if (moment == 'Matin') return "4 Oeufs, Flocons d avoine, 1 Banane";
      if (moment == 'Midi') return "Poulet, Riz complet, Huile d olive";
      return "Saumon, Patates douces, Brocolis";
    } else {
      if (moment == 'Matin') return "Fromage blanc 0%, Amandes";
      if (moment == 'Midi') return "Steak hache 5%, Quinoa, Courgettes";
      return "Salade de thon, Avocat, Tomates";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06090E),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (step == 0) ...[
            const Text("GENRE", style: TextStyle(fontSize: 32, color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            ...['Homme', 'Femme'].map((s) => RadioListTile(title: Text(s, style: const TextStyle(color: Colors.white)), value: s, groupValue: sex, onChanged: (v) => setState(() => sex = v!)))
          ],
          if (step == 1) ...[
            Text("AGE : $age ANS", style: const TextStyle(fontSize: 32, color: Color(0xFF00FF66))),
            Slider(value: age.toDouble(), min: 16, max: 80, onChanged: (v) => setState(() => age = v.toInt()))
          ],
          if (step == 2) ...[
            Text("POIDS : $pds KG", style: const TextStyle(fontSize: 32, color: Color(0xFF00FF66))),
            Slider(value: pds.toDouble(), min: 40, max: 150, onChanged: (v) => setState(() => pds = v.toInt()))
          ],
          if (step == 3) ...[
            Text("TAILLE : $tll CM", style: const TextStyle(fontSize: 32, color: Color(0xFF00FF66))),
            Slider(value: tll.toDouble(), min: 140, max: 220, onChanged: (v) => setState(() => tll = v.toInt()))
          ],
          if (step == 4) ...[
            const Text("OBJECTIF", style: TextStyle(fontSize: 32, color: Color(0xFF00FF66))),
            ...['Muscle', 'Perte de gras'].map((o) => RadioListTile(title: Text(o, style: const TextStyle(color: Colors.white)), value: o, groupValue: obj, onChanged: (v) => setState(() => obj = v!)))
          ],
          if (step == 5) ...[
            Text("OBJECTIF : +$kgMuscle KG", style: const TextStyle(fontSize: 32, color: Color(0xFF00FF66))),
            Slider(value: kgMuscle.toDouble(), min: 1, max: 25, onChanged: (v) => setState(() => kgMuscle = v.toInt()))
          ],
          const Spacer(),
          ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), onPressed: () => setState(() => step++), child: const Text("CONTINUER"))
        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tab == 0 ? "SUIVI" : "REPAS", style: const TextStyle(fontSize: 28, color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => setState(() { step = 0; tab = 0; eauLitre = 0; matin = 'Sain'; midi = 'Sain'; soir = 'Sain'; }), child: const Text("Reset", style: TextStyle(color: Colors.white38)))
          ]),
          const SizedBox(height: 20),
          Expanded(child: SingleChildScrollView(child: tab == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("EAU CONSOMMEE", style: TextStyle(color: Colors.white54)),
            Text("${eauLitre.toStringAsFixed(1)} L", style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold)),
            Slider(value: eauLitre, min: 0.0, max: 6.0, onChanged: (v) => setState(() => eauLitre = v)),
            const SizedBox(height: 20),
            const Text("RESTE A BOIRE", style: TextStyle(color: Colors.white54)),
            Text("${eauRestante.toStringAsFixed(1)} L", style: const TextStyle(fontSize: 36, color: Colors.orange, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            
            // Sélecteurs simplifiés à l'extrême (Boutons simples au lieu de Dropdowns)
            Text("Matin: $matin", style: const TextStyle(color: Colors.white)),
            Row(children: [ElevatedButton(onPressed: () => setState(() => matin = 'Sain'), child: const Text("Sain")), const SizedBox(width: 10), ElevatedButton(onPressed: () => setState(() => matin = 'Malbouffe'), child: const Text("Malbouffe"))]),
            const SizedBox(height: 10),
            Text("Midi: $midi", style: const TextStyle(color: Colors.white)),
            Row(children: [ElevatedButton(onPressed: () => setState(() => midi = 'Sain'), child: const Text("Sain")), const SizedBox(width: 10), ElevatedButton(onPressed: () => setState(() => midi = 'Malbouffe'), child: const Text("Malbouffe"))]),
            const SizedBox(height: 10),
            Text("Soir: $soir", style: const TextStyle(color: Colors.white)),
            Row(children: [ElevatedButton(onPressed: () => setState(() => soir = 'Sain'), child: const Text("Sain")), const SizedBox(width: 10), ElevatedButton(onPressed: () => setState(() => soir = 'Malbouffe'), child: const Text("Malbouffe"))]),
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("OBJECTIF : +$kgMuscle KG", style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Budget : $calCible kcal / jour", style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 20),
            const Text("MATIN", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            Text(getRepas('Matin', matin), style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 20),
            const Text("MIDI", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            Text(getRepas('Midi', midi), style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 20),
            const Text("SOIR", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)),
            Text(getRepas('Soir', soir), style: const TextStyle(color: Colors.white, fontSize: 16)),
          ]))),
          
          // Barre de navigation ultra-basique (Row de boutons texte) pour éviter NavigationBar
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton(onPressed: () => setState(() => tab = 0), child: Text("SUIVI", style: TextStyle(color: tab == 0 ? const Color(0xFF00FF66) : Colors.white24, fontWeight: FontWeight.bold))),
            TextButton(onPressed: () => setState(() => tab = 1), child: Text("PLAN", style: TextStyle(color: tab == 1 ? const Color(0xFF00FF66) : Colors.white24, fontWeight: FontWeight.bold))),
          ])
        ]),
      )),
    );
  }
}
