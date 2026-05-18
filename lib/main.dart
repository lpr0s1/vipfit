import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: VipFit(),
  debugShowCheckedModeBanner: false,
));

class VipFit extends StatefulWidget {
  const VipFit({super.key});
  @override
  State<VipFit> createState() => _VipFitState();
}

class _VipFitState extends State<VipFit> {
  int step = 0;
  int tab = 0;
  int age = 22;
  int pds = 70;
  int tll = 175;
  int kgMuscle = 5;
  double eauLitre = 0.0;
  String sex = 'Homme';
  String obj = 'Muscle';
  String matin = 'Sain';
  String midi = 'Sain';
  String soir = 'Sain';

  int get calCible => ((10 * pds) + (6.25 * tll) - (5 * age) + (sex == 'Homme' ? 5 : -161) + (kgMuscle * 150)).toInt();
  double get eauCible => (pds * 0.035) + (sex == 'Homme' ? 0.5 : 0);
  double get eauRestante => (eauCible - eauLitre) < 0 ? 0.0 : (eauCible - eauLitre);

  String getRepas(String moment, String type) {
    if (type == 'Malbouffe') return "Ajustement requis. Augmentez l'apport en eau de 1L et compensez l'excès au prochain repas.";
    if (obj == 'Muscle') {
      if (moment == 'Matin') return "4 Oeufs entiers, Flocons d'avoine, 1 Banane";
      if (moment == 'Midi') return "Poulet grille, Riz complet, Huile d'olive, Legumes verts";
      return "Saumon sauvage, Patates douces, Brocolis";
    } else {
      if (moment == 'Matin') return "Fromage blanc 0%, Poignee d'amandes";
      if (moment == 'Midi') return "Steak hache 5%, Quinoa, Courgettes sautees";
      return "Salade de thon, Avocat, Tomates cerises";
    }
  }

  // Carte de sélection premium faite main (Zéro dépendance d'icône)
  Widget _buildCard(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1500FF66) : const Color(0xFF161F30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF00FF66) : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00FF66) : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const neon = Color(0xFF00FF66);
    const bgDark = Color(0xFF0A0E17);
    const cardBg = Color(0xFF161F30);
    
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: step < 6 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur de progression sur-mesure ultra-fluide
              Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: step + 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: neon,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6 - (step + 1),
                      child: const SizedBox(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (step == 0) ...[
                const Text("PROFIL", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE GENRE", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 32),
                _buildCard("Homme", sex == 'Homme', () => setState(() => sex = 'Homme')),
                _buildCard("Femme", sex == 'Femme', () => setState(() => sex = 'Femme')),
              ],
              if (step == 1) ...[
                const Text("MESURES", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE ÂGE", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("$age ans", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: neon, letterSpacing: -2)),
                Slider(value: age.toDouble(), min: 16, max: 80, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => age = v.toInt())),
              ],
              if (step == 2) ...[
                const Text("MESURES", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE POIDS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("$pds kg", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: neon, letterSpacing: -2)),
                Slider(value: pds.toDouble(), min: 40, max: 150, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => pds = v.toInt())),
              ],
              if (step == 3) ...[
                const Text("MESURES", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE TAILLE", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("$tll cm", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: neon, letterSpacing: -2)),
                Slider(value: tll.toDouble(), min: 140, max: 220, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => tll = v.toInt())),
              ],
              if (step == 4) ...[
                const Text("OBJECTIF", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE BUT", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 32),
                _buildCard("Prise de muscle", obj == 'Muscle', () => setState(() => obj = 'Muscle')),
                _buildCard("Perte de gras", obj == 'Perte de gras', () => setState(() => obj = 'Perte de gras')),
              ],
              if (step == 5) ...[
                const Text("AMBITION", style: TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("MASSE CIBLE", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("+$kgMuscle kg", style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: neon, letterSpacing: -2)),
                Slider(value: kgMuscle.toDouble(), min: 1, max: 25, activeColor: neon, inactiveColor: cardBg, onChanged: (v) => setState(() => kgMuscle = v.toInt())),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => step++),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: neon,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: neon.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 8))
                    ]
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    step == 5 ? "CONSTRUIRE LE PLAN" : "CONTINUER",
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5),
                  ),
                ),
              )
            ],
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tab == 0 ? "EVOLUTION" : "NUTRITION", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.black, color: Colors.white)),
                  GestureDetector(
                    onTap: () => setState(() { step = 0; tab = 0; eauLitre = 0; matin = 'Sain'; midi = 'Sain'; soir = 'Sain'; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10)),
                      child: const Text("Reset", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: SingleChildScrollView(
                  child: tab == 0 ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("EAU CONSOMMÉE", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text("${eauLitre.toStringAsFixed(1)} L", style: const TextStyle(fontSize: 48, fontWeight: FontWeight.black, color: neon)),
                            Slider(value: eauLitre, min: 0.0, max: 6.0, activeColor: Colors.blueAccent, inactiveColor: bgDark, onChanged: (v) => setState(() => eauLitre = v)),
                            const SizedBox(height: 16),
                            const Text("QUOTA RESTANT", style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text("${eauRestante.toStringAsFixed(1)} L", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: eauRestante == 0 ? neon : Colors.orangeAccent)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text("SUIVI DES REPAS", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                      const SizedBox(height: 14),
                      ...[
                        {'l': 'Matin', 'v': matin, 'c': (s) => setState(() => matin = s)},
                        {'l': 'Midi', 'v': midi, 'c': (s) => setState(() => midi = s)},
                        {'l': 'Soir', 'v': soir, 'c': (s) => setState(() => soir = s)},
                      ].map((r) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r['l'] as String, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            Row(
                              children: ['Sain', 'Ecart'].map((t) => GestureDetector(
                                onTap: () => (r['c'] as Function(String))(t == 'Ecart' ? 'Malbouffe' : 'Sain'),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: (t == 'Sain' && r['v'] == 'Sain') ? neon : (t == 'Ecart' && r['v'] == 'Malbouffe') ? Colors.orangeAccent : bgDark,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      color: r['v'] == (t == 'Ecart' ? 'Malbouffe' : 'Sain') ? Colors.black : Colors.white38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )).toList(),
                            )
                          ],
                        ),
                      ))
                    ],
                  ) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("OBJECTIF : +$kgMuscle KG (${obj.toUpperCase()})", style: const TextStyle(fontSize: 11, color: neon, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 6),
                            Text("$calCible kcal / jour", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.black)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ...['Matin', 'Midi', 'Soir'].map((m) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.toUpperCase(), style: const TextStyle(color: neon, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            const SizedBox(height: 8),
                            Text(
                              getRepas(m, m == 'Matin' ? matin : (m == 'Midi' ? midi : soir)),
                              style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Barre de navigation premium intégrée (Zéro widget externe)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18)),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => tab = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: tab == 0 ? neon : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text("SUIVI", style: TextStyle(color: tab == 0 ? Colors.black : Colors.white38, fontWeight: FontWeight.black, fontSize: 13, letterSpacing: 0.5)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => tab = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: tab == 1 ? neon : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text("REPAS", style: TextStyle(color: tab == 1 ? Colors.black : Colors.white38, fontWeight: FontWeight.black, fontSize: 13, letterSpacing: 0.5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
