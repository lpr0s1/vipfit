import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: WealthVisionUltimate())));

class WealthVisionUltimate extends StatefulWidget {
  const WealthVisionUltimate({super.key});
  @override
  State<WealthVisionUltimate> createState() => _WealthVisionUltimateState();
}

class _WealthVisionUltimateState extends State<WealthVisionUltimate> {
  // --- VARIABLES D'ENTRÉE ---
  double salaire = 2500;
  double capitalTrading = 10000;
  String businessType = "Achat de Box"; 
  String destinationExpat = "France";
  bool isPropFirm = false; // Si l'utilisateur utilise FTMO ou similaire
  bool afficherResultat = false;

  // --- LOGIQUE MÉTIER & CALCULS ---
  
  // 1. Calcul des gains Trading / Prop Firm
  double get gainTradingBrut {
    // On estime une performance réaliste de 5% par mois
    double performanceMensuelle = 0.05;
    return capitalTrading * performanceMensuelle;
  }

  double get gainTradingNet {
    if (isPropFirm) {
      // FTMO prend généralement 20% des gains (tu gardes 80%)
      return gainTradingBrut * 0.80;
    }
    // Trading classique : impôts Flat Tax en France (30%) par défaut pour le calcul de base
    return gainTradingBrut * 0.70;
  }

  // 2. Coût de la vie selon la destination (comparé à un coût de base en France)
  int get coutVieDestination {
    if (destinationExpat == "Bali") return 1200;  // Vie très abordable
    if (destinationExpat == "Dubaï") return 3500; // Vie chère (logement, sorties)
    return 2000; // France (Moyenne globale)
  }

  // 3. Avantages fiscaux de la destination
  double get resteApresImpotExpat {
    double revenusTotaux = salaire + gainTradingNet;
    if (destinationExpat == "Dubaï") return revenusTotaux; // 0% d'impôt sur le revenu
    if (destinationExpat == "Bali") return revenusTotaux * 0.90; // Faible imposition (BNS, etc.)
    return revenusTotaux * 0.80; // France (Charges + Impôt moyen)
  }

  // 4. Reste à vivre réel final
  double get resteAVivreFinal => resteApresImpotExpat - coutVieDestination;

  // 5. Score d'expatriation (Indice de faisabilité)
  String get diagnosticExpat {
    if (resteAVivreFinal < 0) return "❌ Projet Impossible : Tes revenus actuels ne couvrent pas le coût de la vie sur place.";
    if (resteAVivreFinal < 1000) return "⚠️ Projet Risqué : Tu peux y vivre, mais tu manqueras de sécurité financière.";
    return "🟢 Projet Validé ! Tu auras un excellent niveau de vie par rapport à la France.";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("WealthVision Évolution", style: TextStyle(color: Colors.cyan, fontSize: 26, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white10, height: 32),

          if (!afficherResultat) ...[
            // === SECTION 1 : VOS REVENUS ACTUELS ===
            const Text("1. Vos Revenus Actuels", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Salaire Pro : ${salaire.toInt()} €/mois", style: const TextStyle(color: Colors.white)),
            Slider(value: salaire, min: 0, max: 10000, activeColor: Colors.cyan, onChanged: (v) => setState(() => salaire = v)),
            
            const SizedBox(height: 16),
            // === SECTION 2 : TRADING & PROP FIRM ===
            const Text("2. Trading & Capital (FTMO)", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Capital disponible (ou taille de compte) : ${capitalTrading.toInt()} €", style: const TextStyle(color: Colors.white)),
            Slider(value: capitalTrading, min: 2000, max: 200000, activeColor: Colors.cyan, onChanged: (v) => setState(() => capitalTrading = v)),
            
            Row(
              children: [
                const Text("Est-ce un compte Prop Firm (FTMO) ?", style: TextStyle(color: Colors.white70)),
                Checkbox(
                  value: isPropFirm,
                  activeColor: Colors.cyan,
                  checkColor: Colors.black,
                  onChanged: (v) => setState(() => isPropFirm = v!),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // === SECTION 3 : DESTINATION EXPAT ===
            const Text("3. Objectif Expatriation", style: TextStyle(color: Colors.cyan, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Où souhaitez-vous vivre ?", style: TextStyle(color: Colors.white70)),
            DropdownButton<String>(
              value: destinationExpat,
              dropdownColor: const Color(0xFF161F30),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "France", child: Text("Rester en France 🇫🇷")),
                DropdownMenuItem(value: "Bali", child: Text("Partir à Bali (Indonésie) 🇮🇩")),
                DropdownMenuItem(value: "Dubaï", child: Text("Partir à Dubaï (Émirats) 🇦🇪")),
              ],
              onChanged: (v) => setState(() => destinationExpat = v!),
            ),
            
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => afficherResultat = true),
              child: const Text("SIMULER L'EXPATRIATION", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // === BLOC RÉSULTATS INTERNATIONAUX ===
            Text("ANALYSE DE DESTINATION : $destinationExpat", style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Comparatifs des chiffres
            Text("Gains Trading estimés (5% p.m) : +${gainTradingBrut.toInt()} €", style: const TextStyle(color: Colors.white70)),
            Text(isPropFirm ? "Part FTMO déduite (Split 80/20) : ${gainTradingNet.toInt()} €" : "Gain net après impôt de base : ${gainTradingNet.toInt()} €", style: const TextStyle(color: Colors.white54, fontSize: 13)),
            const Divider(color: Colors.white10, height: 24),

            Text("Coût de la vie estimé sur place : ${coutVieDestination} € / mois", style: const TextStyle(color: Colors.orangeAccent)),
            Text(destinationExpat == "France" ? "Fiscalité : Lourde (Impôts + Taxes)" : destinationExpat == "Dubaï" ? "Fiscalité : Exceptionnelle (0% Impôts)" : "Fiscalité : Avantageuse (Zone nomade)", style: const TextStyle(color: Colors.white70)),
            const Divider(color: Colors.white10, height: 24),

            const Text("Reste à vivre REEL sur place :", style: TextStyle(color: Colors.white54)),
            Text("${resteAVivreFinal.toInt()} € / mois", style: TextStyle(color: resteAVivreFinal > 1500 ? Colors.greenWithOpacity(0.9) : Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white.withOpacity(0.05),
              child: Text(diagnosticExpat, style: const TextStyle(color: Colors.white, fontSize: 14), textAlign: TextAlign.center),
            ),
            
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () => setState(() => afficherResultat = false),
              icon: const Icon(Icons.arrow_back, color: Colors.cyan),
              label: const Text("Modifier mon profil et mon capital", style: TextStyle(color: Colors.cyan)),
            ),
          ],
        ],
      ),
    );
  }
}
