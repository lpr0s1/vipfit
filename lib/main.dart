import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Colors.black, body: SafeArea(child: VipFitLab())),
  debugShowCheckedModeBanner: false,
));

class VipFitLab extends StatefulWidget {
  const VipFitLab({super.key});
  @override
  State<VipFitLab> createState() => _VipFitLabState();
}

class _VipFitLabState extends State<VipFitLab> {
  bool show = false;
  
  // Paramètres Biométriques
  String sexe = "Homme";
  int age = 25;
  int poids = 75;
  int taille = 175;
  int reveil = 7;

  // Sélecteur de Points Faibles (Objectifs)
  bool focusPoignets = false;
  bool focusJambes = false;
  bool focusBras = false;
  bool focusDos = false;

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD4AF37);

    // --- LOGIQUE VIP ---
    int cal = (sexe == "Homme") ? (10 * poids + 6 * taille - 5 * age + 500) : (10 * poids + 6 * taille - 5 * age + 200);
    int prot = (poids * 2.2).toInt();
    int gNoix = (poids * 0.4).toInt();
    int gPistache = (poids * 0.5).toInt();
    int hNoix = (reveil + 3) % 24;
    int hPistache = (reveil + 9) % 24;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // HEADER
        const Row(children: [
          Icon(Icons.military_tech, color: gold, size: 30),
          SizedBox(width: 10),
          Text("VIP FIT LAB", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        ]),
        const Divider(color: Colors.white10, height: 40),

        if (!show) ...[
          // === ÉTAPE 1 : PROFIL ATHLÈTE ===
          const _Title("PROFIL BIOMÉTRIQUE"),
          _selector("ÂGE", age, (v) => setState(() => age = v)),
          _selector("POIDS (KG)", poids, (v) => setState(() => poids = v)),
          _selector("TAILLE (CM)", taille, (v) => setState(() => taille = v)),
          _selector("RÉVEIL (H)", reveil, (v) => setState(() => reveil = v)),

          const SizedBox(height: 30),
          // === ÉTAPE 2 : POINTS FAIBLES (L'utilisateur choisit) ===
          const _Title("ZONES À AMÉLIORER (POINTS FAIBLES)"),
          _check("POIGNETS FINS (RENFORCER AVANT-BRAS)", focusPoignets, (v) => setState(() => focusPoignets = v!)),
          _check("JAMBES FINES (MASSE CUISSES/MOLLETS)", focusJambes, (v) => setState(() => focusJambes = v!)),
          _check("BRAS (BICEPS / TRICEPS)", focusBras, (v) => setState(() => focusBras = v!)),
          _check("DOS & ÉPAULES", focusDos, (v) => setState(() => focusDos = v!)),

          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gold, minimumSize: const Size(double.infinity, 55), shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            onPressed: () => setState(() => show = true),
            child: const Text("GÉNÉRER MON PROTOCOLE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ] else ...[
          // === VUE RÉSULTATS (SCREENSHOT READY) ===
          const Center(child: Text("PROTOCOLE DE PERFORMANCE VIP", style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 14))),
          const Divider(color: Colors.white10, height: 30),

          // Nutrition
          const _Title("🎯 MACRONUTRITION CALIBRÉE"),
          _res("Calories de Masse", "$cal kcal"),
          _res("Protéines structurales", "${prot}g"),
          
          const Divider(color: Colors.white10, height: 30),
          
          // Timing Noix / Pistaches
          const _Title("⏳ TIMING PROTOCOLE NUTRITION"),
          _timing(hNoix, "NOIX DE GRENOBLE ($gNoix g)", "Anti-inflammatoire naturel. Protège les tendons des poignets et coudes avant l'effort."),
          _timing(hPistache, "PISTACHES CRUES ($gPistache g)", "Boost L-Arginine. Maximise la vasodilatation (congestion) des bras et jambes."),

          const Divider(color: Colors.white10, height: 30),

          // Entraînement dynamique selon les choix
          const _Title("⚔️ ENTRAÎNEMENT CIBLÉ"),
          if (focusPoignets) _exo("ISOLATION POIGNETS / AVANT-BRAS", "• Curl inversé barre EZ (4x12)\n• Flexions/Extensions poignets haltères (3x20)\n• Farmer Walk (Marche du fermier) 3 séries max"),
          if (focusJambes) _exo("MASSE BAS DU CORPS", "• Squat lourd complet (5x5)\n• Presse à cuisses (4x12)\n• Extensions mollets debout (5x20) - Arrêt 2s en bas"),
          if (focusBras) _exo("VOLUME BRAS (CONGESTION)", "• SuperSet Curl incliné + Dips (4x10)\n• Extension triceps poulie haute (3x15)"),
          if (focusDos) _exo("LARGEUR DOS & ÉPAULES", "• Tractions strictes pronation (4xMax)\n• Développé militaire haltères (4x8)"),

          const SizedBox(height: 40),
          TextButton(
            onPressed: () => setState(() => show = false),
            child: const Text("MODIFIER LE PROFIL", style: TextStyle(color: gold)),
          ),
        ]
      ],
    );
  }

  // --- WIDGETS INTERNES ULTRA-LÉGERS ---
  Widget _selector(String label, int val, Function(int) onChange) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      Row(children: [
        IconButton(icon: const Icon(Icons.remove, color: Color(0xFFD4AF37), size: 18), onPressed: () => onChange(val - 1)),
        Text("$val", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add, color: Color(0xFFD4AF37), size: 18), onPressed: () => onChange(val + 1)),
      ])
    ]),
  );

  Widget _check(String t, bool v, Function(bool?) onC) => CheckboxListTile(
    title: Text(t, style: const TextStyle(color: Colors.white60, fontSize: 12)),
    value: v, onChanged: onC, activeColor: const Color(0xFFD4AF37), checkColor: Colors.black, contentPadding: EdgeInsets.zero,
  );

  Widget _res(String l, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: const TextStyle(color: Colors.white70)), Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
  );

  Widget _timing(int h, String title, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("$h h 00 - $title", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
      Text(desc, style: const TextStyle(color: Colors.white38, fontSize: 11, height: 1.4)),
    ]),
  );

  Widget _exo(String t, String d) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(t, style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold, fontSize: 11)),
      Text(d, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
    ]),
  );
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 20, bottom: 10), child: Text(text, style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)));
  }
}
