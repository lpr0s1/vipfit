import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    brightness: Brightness.dark, 
    useMaterial3: true, 
    colorSchemeSeed: const Color(0xFF00FF66) // Vert Néon Premium
  ),
  home: const VipFit(), debugShowCheckedModeBanner: false
));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int step = 0, tab = 0, age = 22, pds = 70, tll = 175, kgMuscle = 5;
  double eauLitre = 0.0;
  String sex = 'Homme', obj = 'Prendre du muscle';
  
  // Suivi alimentation
  String matin = 'Sain', midi = 'Sain', soir = 'Sain';

  // Calculs des objectifs cibles
  int get calCible => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (kgMuscle * 150)).toInt();
  double get eauCible => (pds * 0.035) + (sex == 'Homme' ? 0.5 : 0);

  // Sécurité anti-chiffres négatifs
  double get eauRestante => (eauCible - eauLitre) < 0 ? 0.0 : (eauCible - eauLitre);

  // Planification des repas Premium selon le profil
  String getRepas(String moment, String type) {
    if (type == 'Malbouffe') return "⚠️ Alerte gras ! Compensez le prochain repas avec des légumes verts et doublez l'eau.";
    if (obj == 'Prendre du muscle') {
      if (moment == 'Matin') return "🍳 4 Œufs, Flocons d'avoine, 1 Banane";
      if (moment == 'Midi') return "🍗 Poulet, Riz complet, Filet d'huile d'olive";
      return "🐟 Pavé de Saumon, Patates douces, Brocolis";
    } else {
      if (moment == 'Matin') return "🥣 Fromage blanc 0%, Poignée d'amandes";
      if (moment == 'Midi') return "🥩 Steak haché 5%, Quinoa, Courgettes";
      return "🥗 Salade de thon, Avocat, Tomates, Huile de colza";
    }
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle titreStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Color(0xFF00FF66), letterSpacing: -0.5);
    const TextStyle chiffreStyle = TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white);
    const TextStyle sousTitreStyle = TextStyle(fontSize: 16, color: Colors.white54);

    return Scaffold(
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: step < 6 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          LinearProgressIndicator(value: (step + 1) / 6, color: const Color(0xFF00FF66)),
          const SizedBox(height: 40),
          if (step == 0) ...[
            const Text("VOTRE GENRE", style: titreStyle),
            const SizedBox(height: 20),
            ...['Homme', 'Femme'].map((s) => RadioListTile(title: Text(s, style: const TextStyle(fontSize: 20)), value: s, groupValue: sex, onChanged: (v) => setState(() => sex = v!)))
          ],
          if (step == 1) ...[
            Text("ÂGE : $age ANS", style: titreStyle),
            const SizedBox(height: 40),
            Slider(value: age.toDouble(), min: 16, max: 80, onChanged: (v) => setState(() => age = v.toInt()))
          ],
          if (step == 2) ...[
            Text("POIDS : $pds KG", style: titreStyle),
            const SizedBox(height: 40),
            Slider(value: pds.toDouble(), min: 40, max: 150, onChanged: (v) => setState(() => pds = v.toInt()))
          ],
          if (step == 3) ...[
            Text("TAILLE : $tll CM", style: titreStyle),
            const SizedBox(height: 40),
            Slider(value: tll.toDouble(), min: 140, max: 220, onChanged: (v) => setState(() => tll = v.toInt()))
          ],
          if (step == 4) ...[
            const Text("VOTRE OBJECTIF", style: titreStyle),
            const SizedBox(height: 20),
            ...['Prendre du muscle', 'Perdre du gras'].map((o) => RadioListTile(title: Text(o, style: const TextStyle(fontSize: 20)), value: o, groupValue: obj, onChanged: (v) => setState(() => obj = v!)))
          ],
          if (step == 5) ...[
            Text("MUSCLE À PRENDRE : +$kgMuscle KG", style: titreStyle),
            const SizedBox(height: 40),
            Slider(value: kgMuscle.toDouble(), min: 1, max: 25, onChanged: (v) => setState(() => kgMuscle = v.toInt()))
          ],
          const Spacer(),
          ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 60), backgroundColor: const Color(0xFF00FF66), foregroundColor: Colors.black), onPressed: () => setState(() => step++), child: Text(step == 5 ? "VOIR MON PLAN ÉLITE" : "CONTINUER", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)))
        ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(tab == 0 ? "SUIVI EAU" : "PLAN REPAS", style: titreStyle),
            IconButton(icon: const Icon(Icons.refresh, color: Colors.white38), onPressed: () => setState(() { step = 0; tab = 0; eauLitre = 0; matin = 'Sain'; midi = 'Sain'; soir = 'Sain'; }))
          ]),
          const SizedBox(height: 30),
          Expanded(child: SingleChildScrollView(child: tab == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text("EAU CONSOMMÉE AUJOURD'HUI", style: sousTitreStyle),
            Text("${eauLitre.toStringAsFixed(1)} L", style: chiffreStyle),
            Slider(value: eauLitre, min: 0.0, max: 6.0, activeColor: const Color(0xFF00E5FF), onChanged: (v) => setState(() => eauLitre = v)),
            const SizedBox(height: 40),
            const Text("OBJECTIF RESTANT", style: sousTitreStyle),
            Text("${eauRestante.toStringAsFixed(1)} L à boire", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: eauRestante == 0 ? const Color(0xFF00FF66) : Colors.orange)),
            Text("Cible totale : ${eauCible.toStringAsFixed(1)} L", style: sousTitreStyle),
            const SizedBox(height: 40),
            const Text("QUALITÉ DE L'ALIMENTATION", style: sousTitreStyle),
            DropdownButtonFormField(value: matin, decoration: const InputDecoration(labelText: "Matin"), items: const [DropdownMenuItem(value: 'Sain', child: Text('Sain 🥦')), DropdownMenuItem(value: 'Malbouffe', child: Text('Malbouffe 🍔'))], onChanged: (v) => setState(() => matin = v!)),
            DropdownButtonFormField(value: midi, decoration: const InputDecoration(labelText: "Midi"), items: const [DropdownMenuItem(value: 'Sain', child: Text('Sain 🥦')), DropdownMenuItem(value: 'Malbouffe', child: Text('Malbouffe 🍔'))], onChanged: (v) => setState(() => midi = v!)),
            DropdownButtonFormField(value: soir, decoration: const InputDecoration(labelText: "Soir"), items: const [DropdownMenuItem(value: 'Sain', child: Text('Sain 🥦')), DropdownMenuItem(value: 'Malbouffe', child: Text('Malbouffe 🍔'))], onChanged: (v) => setState(() => soir = v!)),
          ]) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("OBJECTIF : +$kgMuscle KG ($obj)", style: const TextStyle(fontSize: 18, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold)),
            Text("Budget Énergie : $calCible kcal / jour", style: sousTitreStyle),
            const SizedBox(height: 30),
            Card(child: ListTile(title: const Text("MATIN", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)), subtitle: Text(getRepas('Matin', matin), style: const TextStyle(fontSize: 16)))),
            Card(child: ListTile(title: const Text("MIDI", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)), subtitle: Text(getRepas('Midi', midi), style: const TextStyle(fontSize: 16)))),
            Card(child: ListTile(title: const Text("SOIR", style: TextStyle(color: Color(0xFF00FF66), fontWeight: FontWeight.bold)), subtitle: Text(getRepas('Soir', soir), style: const TextStyle(fontSize: 16)))),
          ]))),
          NavigationBar(
            selectedIndex: tab, onDestinationSelected: (i) => setState(() => tab = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.water_drop, color: Color(0xFF00E5FF)), label: "Hydratation"),
              NavigationDestination(icon: Icon(Icons.restaurant, color: Color(0xFF00FF66)), label: "Plan Nutrition")
            ],
          )
        ]),
      )),
    );
  }
}
