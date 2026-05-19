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

  // --- QUESTIONS SIMPLES ---
  String sexe = "Homme";
  int age = 25;
  int poids = 75;
  int taille = 175;
  int reveil = 7;
  String corpsFin = "Oui, j'ai les poignets ou les jambes fines";
  String zoneAAmeliorer = "Les Bras";

  // Fonction pour afficher les détails dans une jolie popup VIP
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
            child: const Text("OK", style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color orVip = Color(0xFFD4AF37);
    const Color grisFonce = Color(0xFF1C1C1E);

    // Calculs automatiques simples
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRE DE PROGRESSION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("VIP FIT LAB", style: TextStyle(color: orVip, fontWeight: FontWeight.bold, fontSize: 20)),
                Text(afficherPlan ? "MON PLAN" : "QUESTION ${etape + 1} / 7", style: const TextStyle(color: Colors.white30, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),

            // ZONE DYNAMIQUE
            Expanded(
              child: ListView(
                children: [
                  if (!afficherPlan) ...[
                    // --- ÉTAPES DE QUESTIONS (UNE PAR UNE) ---
                    if (etape == 0) _tuileQuestion("ÊTES-VOUS UN HOMME OU UNE FEMME ?", DropdownButton<String>(
                      value: sexe, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => sexe = v!),
                    )),

                    if (etape == 1) _tuileQuestion("QUEL EST VOTRE ÂGE ?", _boutonsPlusMoins(age, (v) => setState(() => age = v), "ans")),
                    if (etape == 2) _tuileQuestion("QUEL EST VOTRE POIDS ?", _boutonsPlusMoins(poids, (v) => setState(() => poids = v), "kg")),
                    if (etape == 3) _tuileQuestion("QUEL EST VOTRE TAILLE ?", _boutonsPlusMoins(taille, (v) => setState(() => taille = v), "cm")),
                    if (etape == 4) _tuileQuestion("À QUELLE HEURE VOUS RÉVEILLEZ-VOUS ?", _boutonsPlusMoins(reveil, (v) => setState(() => reveil = v), "h00")),

                    if (etape == 5) _tuileQuestion("AVEZ-VOUS LES ARTICULATIONS FINES ?", DropdownButton<String>(
                      value: corpsFin, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 14),
                      items: ["Oui, j'ai les poignets ou les jambes fines", "Non, j'ai une morphologie normale"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => corpsFin = v!),
                    )),

                    if (etape == 6) _tuileQuestion("QUELLE ZONE VOULEZ-VOUS AMÉLIORER ?", DropdownButton<String>(
                      value: zoneAAmeliorer, dropdownColor: grisFonce, isExpanded: true, style: const TextStyle(color: Colors.white, fontSize: 16),
                      items: ["Les Bras", "Les Jambes", "Le Dos"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => zoneAAmeliorer = v!),
                    )),
                  ] else ...[
                    // =========================================================
                    // === PLAN DE RÉSULTAT BIEN RANGÉ (SANS TEXTE SOURD) ===
                    // =========================================================
                    
                    // CATEGORIE 1 : ALIMENTATION
                    _titreCategorie("🍏 CATEGORIE 1 : NOURRITURE"),
                    _ligneSimple("Énergie par jour", "$calories Calories"),
                    _ligneSimple("Protéines (médicament du muscle)", "${proteines}g"),
                    
                    const SizedBox(height: 10),
                    _boutonSavoirPlus(
                      "Conseil Noix ($grammesNoix g à ${heureNoix}h00)", 
                      "À prendre à ${heureNoix}h00.\n\nPourquoi ? Les noix de Grenoble contiennent des bons gras qui protègent et lubrifient tes poignets et tes coudes fins pour éviter d'avoir mal en portant lourd.",
                    ),
                    _boutonSavoirPlus(
                      "Conseil Pistaches ($grammesPistaches g à ${heurePistaches}h00)", 
                      "À prendre à ${heurePistaches}h00 (30 minutes avant l'effort).\n\nPourquoi ? Les pistaches dilatent tes vaisseaux sanguins. Cela va forcer le sang à aller se bloquer dans tes bras ou tes jambes pour accélérer la prise de muscle.",
                    ),

                    const SizedBox(height: 25),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 15),

                    // CATEGORIE 2 : SPORT
                    _titreCategorie("💪 CATEGORIE 2 : SPORT & ENTRAÎNEMENT"),
                    _ligneSimple("Votre objectif", "Développer $zoneAAmeliorer"),
                    _ligneSimple("Morphologie", corpsFin.contains("Oui") ? "Ossature fine" : "Ossature normale"),
                    
                    const SizedBox(height: 10),
                    if (corpsFin.contains("Oui")) _boutonSavoirPlus(
                      "🛡️ Exercice spécial Poignets / Articulations",
                      "Puisque tu as les poignets fins, fais cet exercice en priorité :\n\n• La marche du fermier (Farmer Walk) : Prends deux haltères très lourds dans tes mains et marche le plus longtemps possible. Cela va épaissir tes avant-bras et solidifier tes poignets.",
                    ),
                    
                    if (zoneAAmeliorer == "Les Bras") _boutonSavoirPlus(
                      "🏋️ Le programme pour les BRAS",
                      "Fais ces exercices 2 fois par semaine :\n\n1. Curl incliné avec haltères (4 séries de 10 répétitions) pour le volume du biceps.\n2. Dips entre deux bancs (4 séries de 10 répétitions) pour étirer et gonfler le triceps.",
                    ),
                    if (zoneAAmeliorer == "Les Jambes") _boutonSavoirPlus(
                      "🏋️ Le programme pour les JAMBES",
                      "Fais ces exercices 1 fois par semaine :\n\n1. Squat guidé ou libre (4 séries de 8 répétitions) pour prendre de la masse sur les cuisses.\n2. Montées sur pointes debout (5 séries de 20 répétitions) avec un arrêt de 2 secondes en bas pour faire grossir les mollets.",
                    ),
                    if (zoneAAmeliorer == "Le Dos") _boutonSavoirPlus(
                      "🏋️ Le programme pour le DOS",
                      "Fais ces exercices 2 fois par semaine :\n\n1. Tractions à la barre (4 séries du maximum de répétitions possible) pour élargir la carrure.\n2. Rowing assis à la poulie (4 séries de 10 répétitions) pour rendre le dos plus épais.",
                    ),
                  ]
                ],
              ),
            ),

            // BOUTONS DE NAVIGATION
            Row(
              children: [
                if (etape > 0 || afficherPlan)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (afficherPlan) {
                            afficherPlan = false;
                            etape = 6;
                          } else {
                            etape--;
                          }
                        });
                      },
                      child: const Text("RETOUR", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (etape > 0 || afficherPlan) const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: orVip, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      setState(() {
                        if (etape < 6) {
                          etape++;
                        } else {
                          afficherPlan = true;
                        }
                      });
                    },
                    child: Text(
                      etape == 6 && !afficherPlan ? "VOIR MON PLAN" : (afficherPlan ? "ENREGISTRÉ" : "SUIVANT"),
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- PETITS BLOCS DE CONSTRUCTIONS PRÉ-FABRIQUÉS POUR XCODE ---
  Widget _tuileQuestion(String titre, Widget action) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20),
      Text(titre, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      const SizedBox(height: 25),
      action,
    ],
  );

  Widget _boutonsPlusMoins(int valeur, Function(int) auClic, String unite) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text("$valeur $unite", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      Row(
        children: [
          IconButton(icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFD4AF37), size: 30), onPressed: () => auClic(valeur - 1)),
          const SizedBox(width: 15),
          IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4AF37), size: 30), onPressed: () => auClic(valeur + 1)),
        ],
      )
    ],
  );

  Widget _titreCategorie(String nom) => Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 12),
    child: Text(nom, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
  );

  Widget _ligneSimple(String gauche, String droite) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(gauche, style: const TextStyle(color: Colors.white60, fontSize: 13)), Text(droite, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))]),
  );

  Widget _boutonSavoirPlus(String titreBouton, String textePopup) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1C1C1E), minimumSize: const Size(double.infinity, 45), alignment: Alignment.centerLeft, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: () => _ouvrirPopup(titreBouton, textePopup),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titreBouton, style: const TextStyle(color: Colors.white, fontSize: 12)),
          const Text("En savoir +", style: TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}