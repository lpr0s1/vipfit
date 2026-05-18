import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(
  home: WealthVision(),
  debugShowCheckedModeBanner: false,
));

class WealthVision extends StatefulWidget {
  const WealthVision({super.key});
  @override
  State<WealthVision> createState() => _WealthVisionState();
}

class _WealthVisionState extends State<WealthVision> {
  int step = 0;
  int tab = 0;
  
  // Profil
  String sex = 'Homme';
  int age = 30;
  int salaire = 2500;
  int depenses = 1500;

  // Calculs financiers en temps réel
  int get epargneMensuelle => salaire - depenses;
  int get epargneAnnuelle => epargneMensuelle * 12;
  
  // Projection Inflation 2026-2029 (hypothèse moyenne ~2.5% par an sur 3 ans = ~7.7% de perte)
  int get pouvoirAchat2029 => (salaire * 0.923).toInt();
  int get perteInflationAnnuelle => (epargneAnnuelle * 0.077).toInt();

  // Recommandation Expatriation / Villes
  Map<String, String> get destinationRecommandee {
    if (epargneMensuelle < 200) {
      return {"pays": "Bulgarie / Thaïlande", "villeFr": "Limoges / Saint-Étienne", "raison": "Idéal pour maximiser un faible reste à vivre."};
    } else if (epargneMensuelle < 800) {
      return {"pays": "Espagne / Portugal", "villeFr": "Montpellier / Rennes", "raison": "Excellent compromis qualité de vie / coût."};
    } else {
      return {"pays": "Suisse / Emirats", "villeFr": "Annecy / Bordeaux", "raison": "Fiscalité avantageuse pour forte capacité d'épargne."};
    }
  }

  // Calcul Business (Parkings / Terrains)
  Map<String, dynamic> get analyseBusiness {
    // Règle des 35% d'endettement max en France
    double capaciteEmpruntMensuelle = (salaire * 0.35) - depenses; 
    bool peutEmprunter = capaciteEmpruntMensuelle > 50;

    if (epargneMensuelle <= 0) {
      return {"type": "Alerte", "desc": "Réduisez vos dépenses avant d'investir.", "gain": 0, "faisable": false};
    } else if (epargneMensuelle < 300 || !peutEmprunter) {
      return {
        "type": "Parking en Province (ex: Mulhouse, Roubaix)",
        "desc": "Achat comptant ou micro-crédit. Coût ~6 000€. Demande peu d'entretien.",
        "gain": 50,
        "faisable": true
      };
    } else if (epargneMensuelle < 800) {
      return {
        "type": "Lots de Parkings / Garages (ex: Lyon périphérie, Lille)",
        "desc": "Achat à crédit (~15 000€). L'inflation réduit le coût de votre dette.",
        "gain": 120,
        "faisable": true
      };
    } else {
      return {
        "type": "Terrain Agricole / Loisir mis en location",
        "desc": "Achat stratégique (~30 000€). Location pour panneaux solaires ou agriculture.",
        "gain": 350,
        "faisable": true
      };
    }
  }

  // Projection jusqu'à la retraite (estimée à 65 ans)
  int get projectionGains {
    int anneesRestantes = max(0, 65 - age);
    int capitalBrut = epargneAnnuelle * anneesRestantes;
    // Ajout d'intérêts composés basiques (ex: 4% net) sur les gains du business envisagé
    int gainsBusinessAnnuels = analyseBusiness['gain'] * 12;
    return capitalBrut + (gainsBusinessAnnuels * anneesRestantes);
  }

  Widget _buildCard(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1500E5FF) : const Color(0xFF161F30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF00E5FF) : Colors.transparent, width: 2),
        ),
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyle(color: isSelected ? const Color(0xFF00E5FF) : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF00E5FF);
    const bgDark = Color(0xFF0A0E17);
    const cardBg = Color(0xFF161F30);

    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: step < 4 ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity, height: 5,
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(3)),
                child: Row(children: [
                  Expanded(flex: step + 1, child: Container(decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(3)))),
                  Expanded(flex: 4 - (step + 1), child: const SizedBox()),
                ]),
              ),
              const SizedBox(height: 40),
              if (step == 0) ...[
                const Text("ÉTAPE 1", style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("VOTRE PROFIL", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 32),
                _buildCard("Homme", sex == 'Homme', () => setState(() => sex = 'Homme')),
                _buildCard("Femme", sex == 'Femme', () => setState(() => sex = 'Femme')),
                const SizedBox(height: 32),
                Text("$age ans", style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: accent, letterSpacing: -2)),
                Slider(value: age.toDouble(), min: 18, max: 70, activeColor: accent, inactiveColor: cardBg, onChanged: (v) => setState(() => age = v.toInt())),
              ],
              if (step == 1) ...[
                const Text("ÉTAPE 2", style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("REVENU NET", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("$salaire € / mois", style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: accent, letterSpacing: -2)),
                const Text("Incluez votre salaire et autres revenus.", style: TextStyle(color: Colors.white54)),
                Slider(value: salaire.toDouble(), min: 1000, max: 15000, divisions: 140, activeColor: accent, inactiveColor: cardBg, onChanged: (v) => setState(() => salaire = v.toInt())),
              ],
              if (step == 2) ...[
                const Text("ÉTAPE 3", style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("DÉPENSES", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 24),
                Text("$depenses € / mois", style: const TextStyle(fontSize: 54, fontWeight: FontWeight.w900, color: accent, letterSpacing: -2)),
                const Text("Loyer, courses, abonnements, crédits en cours.", style: TextStyle(color: Colors.white54)),
                Slider(value: depenses.toDouble(), min: 500, max: 10000, divisions: 95, activeColor: accent, inactiveColor: cardBg, onChanged: (v) => setState(() => depenses = v.toInt())),
              ],
              if (step == 3) ...[
                const Text("SYNTHÈSE", style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 3)),
                const SizedBox(height: 8),
                const Text("CAPACITÉ", style: TextStyle(fontSize: 32, fontWeight: FontWeight.black, color: Colors.white)),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text("ÉPARGNE POTENTIELLE", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text("$epargneMensuelle € / mois", style: TextStyle(fontSize: 36, fontWeight: FontWeight.black, color: epargneMensuelle > 0 ? accent : Colors.redAccent)),
                  ]),
                ),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (epargneMensuelle < 0 && step == 3) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vos dépenses dépassent vos revenus."), backgroundColor: Colors.redAccent));
                    return;
                  }
                  setState(() => step++);
                },
                child: Container(
                  width: double.infinity, height: 56,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: accent.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 8))]),
                  alignment: Alignment.center,
                  child: Text(step == 3 ? "LANCER L'ANALYSE" : "CONTINUER", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 0.5)),
                ),
              )
            ],
          ) : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(tab == 0 ? "2026 - 2029" : tab == 1 ? "EXPATRIATION" : "BUSINESS", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.black, color: Colors.white)),
                  GestureDetector(
                    onTap: () => setState(() { step = 0; tab = 0; }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(10)),
                      child: const Text("Edit", style: TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),
              Expanded(
                child: SingleChildScrollView(
                  child: tab == 0 ? Column( // TAB 0 : INFLATION & EPARGNE
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("PROJECTION INFLATION 2029", style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          const SizedBox(height: 16),
                          const Text("Salaire perçu actuellement", style: TextStyle(color: Colors.white54, fontSize: 13)),
                          Text("$salaire €", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          const Text("Pouvoir d'achat réel estimé en 2029", style: TextStyle(color: Colors.white54, fontSize: 13)),
                          Text("$pouvoirAchat2029 €", style: const TextStyle(color: Colors.orangeAccent, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text("Perte estimée sur votre épargne : $perteInflationAnnuelle € / an. Il est crucial d'investir.", style: const TextStyle(color: Colors.white38, fontSize: 12, height: 1.5)),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("CAPITAL À ${max(age, 65)} ANS", style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          const SizedBox(height: 8),
                          Text("$projectionGains €", style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.black)),
                          const SizedBox(height: 8),
                          Text("Estimation basée sur une épargne constante et le lancement du business recommandé.", style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5)),
                        ]),
                      ),
                    ],
                  ) : tab == 1 ? Column( // TAB 1 : EXPATRIATION
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("TERRITOIRE FRANÇAIS OPTIMAL", style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          Text(destinationRecommandee['villeFr']!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text("Sur la base de votre reste à vivre de $epargneMensuelle €/mois, ces régions maximisent votre confort.", style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)),
                        ]),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text("EXPATRIATION RECOMMANDÉE", style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          Text(destinationRecommandee['pays']!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(destinationRecommandee['raison']!, style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)),
                        ]),
                      ),
                    ],
                  ) : Column( // TAB 2 : BUSINESS
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity, padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(20)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("BUSINESS ADAPTÉ À VOTRE PROFIL (${sex == 'Homme' ? 'H' : 'F'} - $age ANS)", style: const TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
                          const SizedBox(height: 16),
                          Text(analyseBusiness['type'], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)),
                          const SizedBox(height: 12),
                          Text(analyseBusiness['desc'], style: const TextStyle(color: Colors.white54, fontSize: 14, height: 1.5)),
                          const SizedBox(height: 24),
                          const Text("REVENU PASSIF ESTIMÉ", style: TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
                          Text("+ ${analyseBusiness['gain']} € / mois", style: TextStyle(color: analyseBusiness['faisable'] ? accent : Colors.redAccent, fontSize: 32, fontWeight: FontWeight.black)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Navigation
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(18)),
                child: Row(
                  children: [
                    _navButton(0, "BILAN"),
                    _navButton(1, "VILLES"),
                    _navButton(2, "BUSINESS"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navButton(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: tab == index ? const Color(0xFF00E5FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: tab == index ? Colors.black : Colors.white38, fontWeight: FontWeight.black, fontSize: 12, letterSpacing: 0.5)),
        ),
      ),
    );
  }
}
