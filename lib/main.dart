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
  bool afficherPlan = false;

  // --- PARAMÈTRES ATHLÈTE ---
  String sexe = "Homme";
  int age = 25;
  int poids = 75;
  int taille = 175;
  int reveil = 7;
  int eauActuelle = 2;
  String corpsFin = "Oui, j'ai les poignets ou les jambes fines";
  String zoneAAmeliorer = "Les Bras";

  // Fonction Popup pour garder l'écran propre
  void _ouvrirPopup(String titre, String texte) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(titre, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text(texte, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("COMPRIS", style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color orVip = Color(0xFFD4AF37);
    const Color grisFonce = Color(0xFF1C1C1E);

    // --- CALCULS DYNAMIQUES ---
    String statutTaille = (taille < 170) ? "Petit" : (taille > 185) ? "Grand" : "Moyen";
    String statutPoids = (poids < 65) ? "Léger" : (poids > 85) ? "Lourd" : "Moyen";

    double eauIdeale = (poids * 0.035);
    double eauManquante = (eauIdeale - eauActuelle) > 0 ? (eauIdeale - eauActuelle) : 0;

    int calories = (poids * 30) + 400; 
    int proteines = poids * 2;
    int grammesNoix = (poids * 0.4).toInt();
    int grammesPistaches = (poids * 0.5).toInt();
    int heureNoix = (reveil + 3) % 24;
    int heurePistaches = (reveil + 9) % 24;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset('assets/app_icon.png', width: 30, height: 30),
                const SizedBox(width: 12),
                const Text("VIP FIT LAB", style: TextStyle(color: orVip, fontWeight: FontWeight.bold, fontSize: 20)),
                const Spacer(),
                Text(afficherPlan ? "RÉSULTAT" : "ÉTAPE ${etape + 1} / 8", style: const TextStyle(color: Colors.white30, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 15),
            LinearProgressIndicator(value: afficherPlan ? 1.0 : (etape + 1) / 8, backgroundColor: Colors.white10, valueColor: const AlwaysStoppedAnimation<Color>(orVip)),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  if (!afficherPlan) ...[
                    if (etape == 0) _tuileQuestion("SEXE", DropdownButton<String>(
                      value: sexe, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => sexe = v!),
                    )),
                    if (etape == 1) _tuileQuestion("ÂGE", _boutonsPlusMoins(age, (v) => setState(() => age = v), "ans")),
                    if (etape == 2) _tuileQuestion("POIDS ($statutPoids)", _boutonsPlusMoins(poids, (v) => setState(() => poids = v), "kg")),
                    if (etape == 3) _tuileQuestion("TAILLE ($statutTaille)", _boutonsPlusMoins(taille, (v) => setState(() => taille = v), "cm")),
                    if (etape == 4) _tuileQuestion("HEURE RÉVEIL", _boutonsPlusMoins(reveil, (v) => setState(() => reveil = v), "h00")),
                    if (etape == 5) _tuileQuestion("EAU PAR JOUR", _boutonsPlusMoins(eauActuelle, (v) => setState(() => eauActuelle = v), "L")),
                    if (etape == 6) _tuileQuestion("STRUCTURE ARTICULAIRE", DropdownButton<String>(
                      value: corpsFin, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 14),
                      items: ["Oui, j'ai les poignets ou les jambes fines", "Non, j'ai une morphologie normale"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => corpsFin = v!),
                    )),
                    if (etape == 7) _tuileQuestion("ZONE À AMÉLIORER", DropdownButton<String>(
                      value: zoneAAmeliorer, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: ["Les Bras", "Les Jambes", "Le Dos"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => zoneAAmeliorer = v!),
                    )),
                  ] else ...[
                    _titreCategorie("ALIMENTATION", Icons.restaurant_menu),
                    _ligneSimple("Calories journalières", "$calories kcal"),
                    _ligneSimple("Protéines cibles", "${proteines}g"),
                    _boutonSavoirPlus("💧 Eau : +${eauManquante.toStringAsFixed(1)}L nécessaires", "Ton corps a besoin de ${eauIdeale.toStringAsFixed(1)}L. Tu en manques ${eauManquante.toStringAsFixed(1)}L."),
                    _boutonSavoirPlus("🥜 Noix ($grammesNoix g) à ${heureNoix}h00", "Protège tes articulations."),
                    _boutonSavoirPlus("⚡ Pistaches ($grammesPistaches g) à ${heurePistaches}h00", "Boost de congestion avant sport."),
                    
                    const SizedBox(height: 20),
                    _titreCategorie("SPORT", Icons.fitness_center),
                    _ligneSimple("Objectif", zoneAAmeliorer),
                    if (corpsFin.contains("Oui")) _boutonSavoirPlus("🛡️ Exercice Spécial Articulations", "Marche du fermier pour renforcer tes poignets/chevilles."),
                    _boutonSavoirPlus("🏋️ Programme $zoneAAmeliorer", "Clique pour voir les exercices adaptés à ton profil $statutPoids."),
                  ]
                ],
              ),
            ),
            
            // NAVIGATION
            Row(
              children: [
                if (etape > 0 || afficherPlan) Expanded(child: TextButton(onPressed: () => setState(() => afficherPlan ? afficherPlan = false : etape--), child: const Text("RETOUR", style: TextStyle(color: Colors.white30)))),
                const SizedBox(width: 15),
                Expanded(child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: orVip, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  onPressed: () => setState(() => etape < 7 ? etape++ : afficherPlan = true),
                  child: Text(etape == 7 && !afficherPlan ? "GÉNÉRER" : "SUIVANT", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _tuileQuestion(String titre, Widget action) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 20), Text(titre, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)), const SizedBox(height: 15), action]);
  Widget _boutonsPlusMoins(int v, Function(int) f, String u) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("$v $u", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)), Row(children: [IconButton(icon: const Icon(Icons.remove, color: Color(0xFFD4AF37)), onPressed: () => f(v - 1)), IconButton(icon: const Icon(Icons.add, color: Color(0xFFD4AF37)), onPressed: () => f(v + 1))])]);
  Widget _titreCategorie(String n, IconData i) => Padding(padding: const EdgeInsets.only(top: 20, bottom: 10), child: Row(children: [Icon(i, color: const Color(0xFFD4AF37), size: 16), const SizedBox(width: 8), Text(n, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold))]));
  Widget _ligneSimple(String g, String d) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(g, style: const TextStyle(color: Colors.white60)), Text(d, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]));
  Widget _boutonSavoirPlus(String t, String txt) => ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C1C1E), minimumSize: const Size(double.infinity, 45), alignment: Alignment.centerLeft, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)), onPressed: () => _ouvrirPopup(t, txt), child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)));
}