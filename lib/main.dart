import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipStepApp())),
  debugShowCheckedModeBanner: false,
));

class VipStepApp extends StatefulWidget {
  const VipStepApp({super.key});
  @override
  State<VipStepApp> createState() => _VipStepAppState();
}

class _VipStepAppState extends State<VipStepApp> {
  int currentStep = 0;
  bool showResult = false;

  // --- DONNÉES DE L'ATHLÈTE COLECTÉES ÉTAPE PAR ÉTAPE ---
  String sexe = "Homme";
  int age = 25;
  int poids = 75;
  int taille = 175;
  int reveil = 7;
  String ossature = "Fine (Poignets / Chevilles fins)";
  String ciblePrincipale = "Prendre de la masse autour des articulations fines";

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);
    const Color darkCard = Color(0xFF1C1C1E);

    // --- ALGORITHME DE SYNTHÈSE DES DONNÉES ---
    int cal = (sexe == "Homme") ? (10 * poids + 6 * taille - 5 * age + 550) : (10 * poids + 6 * taille - 5 * age + 250);
    int prot = (poids * 2.2).toInt();
    int gNoix = (poids * 0.4).toInt();
    int gPistache = (poids * 0.5).toInt();
    int hNoix = (reveil + 3) % 24;
    int hPistache = (reveil + 9) % 24;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRE DE PROGRESSION HAUT DE GAMME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("VIP FIT LAB", style: const TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                Text(showResult ? "DIAGNOSTIC TERMINÉ" : "ÉTAPE ${currentStep + 1} / 7", style: const TextStyle(color: Colors.white30, fontSize: 11)),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: showResult ? 1.0 : (currentStep + 1) / 7,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(gold),
              minHeight: 2,
            ),
            const SizedBox(height: 30),

            // ZONE DYNAMIQUE (QUESTION UNIQUE OU RÉSULTAT)
            Expanded(
              child: ListView(
                children: [
                  if (!showResult) ...[
                    // --- ÉTAPE 0 : SEXE ---
                    if (currentStep == 0) _buildStepCard(
                      Icons.person, "QUEL EST VOTRE SEXE BIOLOGIQUE ?",
                      DropdownButton<String>(
                        value: sexe, dropdownColor: darkCard, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        isExpanded: true, underline: Container(height: 1, color: gold),
                        items: ["Homme", "Femme"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => sexe = v!),
                      ),
                    ),

                    // --- ÉTAPE 1 : ÂGE ---
                    if (currentStep == 1) _buildStepCard(
                      Icons.cake, "QUEL EST VOTRE ÂGE ?",
                      _counterRow(age, (v) => setState(() => age = v), "ans"),
                    ),

                    // --- ÉTAPE 2 : POIDS ---
                    if (currentStep == 2) _buildStepCard(
                      Icons.scale, "QUEL EST VOTRE POIDS ACTUEL ?",
                      _counterRow(poids, (v) => setState(() => poids = v), "kg"),
                    ),

                    // --- ÉTAPE 3 : TAILLE ---
                    if (currentStep == 3) _buildStepCard(
                      Icons.straighten, "QUEL EST VOTRE TAILLE ?",
                      _counterRow(taille, (v) => setState(() => taille = v), "cm"),
                    ),

                    // --- ÉTAPE 4 : RÉVEIL ---
                    if (currentStep == 4) _buildStepCard(
                      Icons.alarm, "À QUELLE HEURE VOUS RÉVEILLEZ-VOUS ?",
                      _counterRow(reveil, (v) => setState(() => reveil = v), "h00"),
                    ),

                    // --- ÉTAPE 5 : OSSATURE ---
                    if (currentStep == 5) _buildStepCard(
                      Icons.gavel, "QUELLE EST VOTRE STRUCTURE OSSEUSE ?",
                      DropdownButton<String>(
                        value: ossature, dropdownColor: darkCard, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        isExpanded: true, underline: Container(height: 1, color: gold),
                        items: ["Fine (Poignets / Chevilles fins)", "Intermédiaire", "Lourde / Épaisse"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => ossature = v!),
                      ),
                    ),

                    // --- ÉTAPE 6 : OBJECTIF TARGET ---
                    if (currentStep == 6) _buildStepCard(
                      Icons.ads_click, "QUEL EST VOTRE OBJECTIF PRIORITAIRE ?",
                      DropdownButton<String>(
                        value: ciblePrincipale, dropdownColor: darkCard, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        isExpanded: true, underline: Container(height: 1, color: gold),
                        items: [
                          "Prendre de la masse autour des articulations fines",
                          "Élargir le dos et casser le profil ectomorphe",
                          "Prendre du volume rapidement sur les bras (Biceps/Triceps)",
                          "Développer l'épaisseur des cuisses et mollets"
                        ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (v) => setState(() => ciblePrincipale = v!),
                      ),
                    ),
                  ] else ...[
                    // =========================================================
                    // === VUE PLAN EN 4 PARTIES (SCREENSHOT COMPACT) ===
                    // =========================================================
                    
                    // PARTIE 1
                    _sectionHeader("PARTIE 1 : DIAGNOSTIC BIOMÉTRIQUE"),
                    _rowInfo("Profil Analysé", "$sexe, $age ans, $taille cm"),
                    _rowInfo("Indice de Structure", ossature),
                    _rowInfo("Priorité Détectée", ciblePrincipale),
                    
                    const Divider(color: Colors.white10, height: 30),

                    // PARTIE 2
                    _sectionHeader("PARTIE 2 : MACRONUTRITION & LIPIDES UTILES"),
                    _rowInfo("Apport de Masse", "$cal kcal / jour"),
                    _rowInfo("Protéines de Synthèse", "${prot}g / jour"),
                    
                    const Divider(color: Colors.white10, height: 30),

                    // PARTIE 3
                    _sectionHeader("PARTIE 3 : TIMING CHRONO-NUTRITION"),
                    _timingRow(hNoix, "Collation Noix ($gNoix g)", "Noix de Grenoble riches en Oméga-3. Indispensable pour ton ossature: renforce et lubrifie la structure tendineuse des poignets fins avant les charges lourdes."),
                    _timingRow(hPistache, "Fenêtre de Congestion ($gPistache g)", "Pistaches crues 30 min avant l'effort. Sa concentration en L-Arginine force l'afflux d'oxyde nitrique pour dilater et forcer la masse musculaire autour de tes membres fins."),

                    const Divider(color: Colors.white10, height: 30),

                    // PARTIE 4
                    _sectionHeader("PARTIE 4 : PROTOCOLE MÉCANIQUE CIBLÉ"),
                    if (ossature.contains("Fine") || ciblePrincipale.contains("articulations")) ...[
                      _exoBlock("Focus Avant-Bras & Poignets (Épaississement)", "• Curl inversé barre EZ (4x12) + Extensions poignets assis (3x20)\n• Extensions statiques suspendues ou Farmer Walk lourd pour le grip."),
                    ],
                    if (ciblePrincipale.contains("dos") || ciblePrincipale.contains("ectomorphe")) ...[
                      _exoBlock("Focus Largeur Postérieure", "• Tractions strictes prise large pronation (4xMax)\n• Rowing barre buste penché (4x8) + Oiseau haltères (3x15)"),
                    ],
                    if (ciblePrincipale.contains("bras")) ...[
                      _exoBlock("Focus Hypertrophie des Bras", "• SuperSet : Curl incliné haltères + Dips barres parallèles lestés (4x10)\n• Curl marteau lourd assis (3x12) pour l'épaisseur du long supinateur."),
                    ],
                    if (ciblePrincipale.contains("cuisses") || ossature.contains("Fine")) ...[
                      _exoBlock("Focus Extension Bas du Corps", "• Squat lourd complet (4x6) + Soulevé de terre jambes tendues (3x8)\n• Extensions mollets debout (5x20) avec temps d'arrêt de 2 secondes en bas."),
                    ],
                  ]
                ],
              ),
            ),

            // BARRE DE NAVIGATION INFÉRIEURE
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentStep > 0 || showResult)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          if (showResult) {
                            showResult = false;
                            currentStep = 6;
                          } else {
                            currentStep--;
                          }
                        });
                      },
                      child: const Text("RETOUR", style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
                    ),
                  ),
                if (currentStep > 0 || showResult) const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 50), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    onPressed: () {
                      setState(() {
                        if (currentStep < 6) {
                          currentStep++;
                        } else {
                          showResult = true;
                        }
                      });
                    },
                    child: Text(
                      currentStep == 6 && !showResult ? "GÉNÉRER" : (showResult ? "CONSERVÉ" : "SUIVANT"),
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

  // --- BLOCS DE COMPOSANTS "FLAT" (ZÉRO CHARGE XCODE) ---
  Widget _buildStepCard(IconData icon, String title, Widget action) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 40),
        const SizedBox(height: 15),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        const SizedBox(height: 30),
        action,
      ],
    );
  }

  Widget _counterRow(int value, Function(int) onUpdate, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$value $unit", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFD4AF37), size: 28), onPressed: () => onUpdate(value - 1)),
            const SizedBox(width: 10),
            IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4AF37), size: 28), onPressed: () => onUpdate(value + 1)),
          ],
        )
      ],
    );
  }

  Widget _sectionHeader(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(text, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
  );

  Widget _rowInfo(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)), Text(val, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))]),
  );

  Widget _timingRow(int heure, String title, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("• ${heure}h00 | $title", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 2),
        Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11, height: 1.4)),
      ],
    ),
  );

  Widget _exoBlock(String zone, String liste) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(zone, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      const SizedBox(height: 4),
      Text(liste, style: const TextStyle(color: Colors.white54, fontSize: 11, height: 1.4)),
    ],
  );
}
