import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: WealthVisionElite()),
  debugShowCheckedModeBanner: false,
));

class WealthVisionElite extends StatefulWidget {
  const WealthVisionElite({super.key});
  @override
  State<WealthVisionElite> createState() => _WealthVisionEliteState();
}

class _WealthVisionEliteState extends State<WealthVisionElite> {
  // --- DONNÉES ---
  double salaire = 2500;
  double capitalTrading = 50000;
  bool isPropFirm = true;
  String paysCible = "Bali";
  bool afficherResultat = false;

  // --- LIFESTYLE (Activités) ---
  bool luxeJetSki = false; // ~200€/mois (moyenne)
  bool luxeResto = false;  // ~400€/mois
  bool luxeSport = false;  // ~100€/mois

  // --- CALCULS LOGIQUES ---
  double get gainTrading => isPropFirm ? (capitalTrading * 0.05) * 0.80 : (capitalTrading * 0.05) * 0.70;
  
  double get totalRevenusBrut => salaire + gainTrading;

  // Coût de la vie de base + Activités
  int get fraisFixesExpat {
    if (paysCible == "Bali") return 1100;
    if (paysCible == "Dubaï") return 3200;
    return 1900; // France
  }

  int get coutActivites {
    int total = 0;
    if (luxeJetSki) total += 250;
    if (luxeResto) total += 500;
    if (luxeSport) total += 100;
    return total;
  }

  double get resteAVivreFinal {
    double fiscalite = (paysCible == "Dubaï") ? 1.0 : (paysCible == "Bali" ? 0.95 : 0.78);
    return (totalRevenusBrut * fiscalite) - fraisFixesExpat - coutActivites;
  }

  @override
  Widget build(BuildContext context) {
    const cyan = Color(0xFF00E5FF);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("WEALTHVISION ELITE", style: TextStyle(color: cyan, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 5),
          const Text("Calculateur de Lifestyle & Expatriation", style: TextStyle(color: Colors.white38, fontSize: 12)),
          const Divider(color: Colors.white10, height: 40),

          if (!afficherResultat) ...[
            // SECTION REVENUS
            _label("REVENUS & TRADING"),
            _card(Column(children: [
              Text("Salaire: ${salaire.toInt()}€", style: const TextStyle(color: Colors.white)),
              Slider(value: salaire, min: 0, max: 10000, activeColor: cyan, onChanged: (v) => setState(() => salaire = v)),
              Text("Compte Trading: ${capitalTrading.toInt()}€", style: const TextStyle(color: Colors.white)),
              Slider(value: capitalTrading, min: 0, max: 200000, activeColor: cyan, onChanged: (v) => setState(() => capitalTrading = v)),
              CheckboxListTile(
                title: const Text("Compte Prop Firm (FTMO)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                value: isPropFirm, activeColor: cyan, onChanged: (v) => setState(() => isPropFirm = v!),
              ),
            ])),

            // SECTION DESTINATION
            _label("DESTINATION"),
            _card(DropdownButton<String>(
              value: paysCible, isExpanded: true, dropdownColor: const Color(0xFF161F30),
              style: const TextStyle(color: cyan, fontWeight: FontWeight.bold),
              items: ["France", "Bali", "Dubaï"].map((String p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => setState(() => paysCible = v!),
            )),

            // SECTION ACTIVITÉS (DÉDUCTIONS)
            _label("VOTRE LIFESTYLE (Activités / mois)"),
            _card(Column(children: [
              _switch("Jet-Ski / Loisirs (+250€)", luxeJetSki, (v) => setState(() => luxeJetSki = v)),
              _switch("Restaurants Gastronomiques (+500€)", luxeResto, (v) => setState(() => luxeResto = v)),
              _switch("Coach Privé / Salle Elite (+100€)", luxeSport, (v) => setState(() => luxeSport = v)),
            ])),

            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: cyan, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => setState(() => afficherResultat = true),
              child: const Text("VOIR MON RESTE À VIVRE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // VUE RÉSULTATS
            _resultBox("Revenus Net Trading", "${gainTrading.toInt()}€"),
            _resultBox("Coût Vie ($paysCible)", "-$fraisFixesExpat€"),
            _resultBox("Coût Lifestyle choisi", "-$coutActivites€"),
            const Divider(color: Colors.white24, height: 40),
            
            const Center(child: Text("RESTE À VIVRE FINAL :", style: TextStyle(color: Colors.white54, fontSize: 14))),
            Center(child: Text("${resteAVivreFinal.toInt()} €", style: TextStyle(color: resteAVivreFinal > 0 ? cyan : Colors.redAccent, fontSize: 48, fontWeight: FontWeight.bold))),
            
            const SizedBox(height: 30),
            Text(
              resteAVivreFinal > 2000 ? "🔥 LIBERTÉ TOTALE : Tu vis comme un roi à $paysCible." : (resteAVivreFinal > 0 ? "✅ OK : Tu couvres tes dépenses et tes loisirs." : "❌ OVERBUDGET : Réduis tes activités ou augmente ton capital."),
              style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => setState(() => afficherResultat = false),
              child: const Text("MODIFIER MON PROFIL", style: TextStyle(color: cyan)),
            ),
          ],
        ],
      ),
    );
  }

  // --- WIDGETS UI LIGHT (Xcode Friendly) ---
  Widget _label(String text) => Padding(padding: const EdgeInsets.only(bottom: 10, top: 20), child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)));

  Widget _card(Widget child) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: const Color(0xFF161F30), borderRadius: BorderRadius.circular(15)), child: child);

  Widget _switch(String t, bool v, Function(bool) onChanged) => SwitchListTile(title: Text(t, style: const TextStyle(color: Colors.white, fontSize: 13)), value: v, activeColor: const Color(0xFF00E5FF), onChanged: onChanged);

  Widget _resultBox(String t, String v) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(t, style: const TextStyle(color: Colors.white70)), Text(v, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]));
}
