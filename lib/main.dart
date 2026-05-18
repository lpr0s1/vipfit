import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
  home: WealthVisionMini(),
  debugShowCheckedModeBanner: false,
));

class WealthVisionMini extends StatefulWidget {
  const WealthVisionMini({super.key});
  @override
  State<WealthVisionMini> createState() => _WealthVisionMiniState();
}

class _WealthVisionMiniState extends State<WealthVisionMini> {
  int step = 0;
  double salaire = 2500;
  double depenses = 1500;

  // Calculs simplifiés pour le test
  double get epargneMensuelle => salaire - depenses;
  double get pouvoirAchat2029 => salaire * 0.923;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00E5FF);
    const bgDark = Color(0xFF0A0E17);
    const cardBg = Color(0xFF161F30);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicateur d'étape
              Text(
                step == 0 ? "ÉTAPE 1 SUR 2" : "ANALYSE DU PROFIL",
                style: const TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 8),
              Text(
                step == 0 ? "Vos Finances" : "Vos Projections",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.black, color: Colors.white),
              ),
              const SizedBox(height: 32),
              
              // Contenu dynamique selon l'étape
              Expanded(
                child: SingleChildScrollView(
                  child: step == 0 
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Revenu Net : ${salaire.toInt()} € / mois", style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Slider(value: salaire, min: 1000, max: 10000, activeColor: accent, inactiveColor: cardBg, onChanged: (v) => setState(() => salaire = v)),
                          const SizedBox(height: 24),
                          Text("Dépenses : ${depenses.toInt()} € / mois", style: const TextStyle(color: Colors.white, fontSize: 16)),
                          Slider(value: depenses, min: 500, max: 5000, activeColor: accent, inactiveColor: cardBg, onChanged: (v) => setState(() => depenses = v)),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            width: double.infinity, padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text("RESTE À VIVRE", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("${epargneMensuelle.toInt()} € / mois", style: TextStyle(color: epargneMensuelle >= 0 ? accent : Colors.redAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity, padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text("POUVOIR D'ACHAT RÉEL EN 2029", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text("${pouvoirAchat2029.toInt()} €", style: const TextStyle(color: Colors.orangeAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        ],
                      ),
                ),
              ),
              
              // Bouton principal d'action
              GestureDetector(
                onTap: () => setState(() => step = step == 0 ? 1 : 0),
                child: Container(
                  width: double.infinity, height: 56,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text(step == 0 ? "LANCER L'ANALYSE" : "RETOUR", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
