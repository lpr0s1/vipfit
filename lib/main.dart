import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: WealthVisionSingle())));

class WealthVisionSingle extends StatefulWidget {
  const WealthVisionSingle({super.key});
  @override
  State<WealthVisionSingle> createState() => _WealthVisionSingleState();
}

class _WealthVisionSingleState extends State<WealthVisionSingle> {
  // Variables de profil
  double salaire = 2500;
  double age = 30;
  String villeSecteur = "75";
  String businessType = "Achat de Box"; 
  bool afficherResultat = false; // Gère l'affichage des blocs

  // Calculs métiers directs
  bool get isZoneVerte => 
    villeSecteur == "75" || villeSecteur == "92" || villeSecteur == "69" || 
    villeSecteur.toLowerCase() == "paris" || villeSecteur.toLowerCase() == "lyon";

  double get capaciteEmprunt => salaire * 0.35;

  double get probaReussite {
    double base = isZoneVerte ? 85.0 : 45.0;
    if (businessType == "Container") base -= 10.0;
    if (age < 21 || age > 60) base -= 15.0;
    return base.clamp(0.0, 100.0);
  }

  double get gainEstimeMois {
    double multi = isZoneVerte ? 1.2 : 0.7;
    if (businessType == "Location") return (capaciteEmprunt / 100) * 45 * multi;
    if (businessType == "Container") return (capaciteEmprunt / 250) * 160 * multi;
    return (capaciteEmprunt / 150) * 110 * multi;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text("WealthVision Mini", style: TextStyle(color: Colors.cyan, fontSize: 28, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white10, height: 32),

          if (!afficherResultat) ...[
            // BLOC FORMULAIRE
            Text("Votre profil : ${age.toInt()} ans | ${salaire.toInt()} €/mois", style: const TextStyle(color: Colors.white)),
            Slider(value: age, min: 18, max: 75, activeColor: Colors.cyan, onChanged: (v) => setState(() => age = v)),
            Slider(value: salaire, min: 1200, max: 7000, activeColor: Colors.cyan, onChanged: (v) => setState(() => salaire = v)),
            
            const SizedBox(height: 16),
            const Text("Secteur (Département ou Ville) :", style: TextStyle(color: Colors.white70)),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: "Ex: 75 ou Paris", hintStyle: TextStyle(color: Colors.white24)),
              onChanged: (v) => setState(() => villeSecteur = v),
            ),
            
            const SizedBox(height: 24),
            const Text("Type de Projet :", style: TextStyle(color: Colors.white70)),
            DropdownButton<String>(
              value: businessType,
              dropdownColor: const Color(0xFF161F30),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Achat de Box", child: Text("Achat de Box classique")),
                DropdownMenuItem(value: "Location", child: Text("Sous-location / Conciergerie")),
                DropdownMenuItem(value: "Container", child: Text("Container Maritime")),
              ],
              onChanged: (v) => setState(() => businessType = v!),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => setState(() => afficherResultat = true),
              child: const Text("LANCER L'ANALYSE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            // BLOC RÉSULTATS
            Text(isZoneVerte ? "ZONAGE : VERT (Forte demande 🟢)" : "ZONAGE : ROUGE (Marché risqué 🔴)", 
                 style: TextStyle(color: isZoneVerte ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            
            Text("Capacité d'emprunt maximale : ${capaciteEmprunt.toInt()} €", style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text("Probabilité de succès : ${probaReussite.toInt()}%", 
                 style: TextStyle(color: probaReussite > 50 ? Colors.greenAccent : Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            const Text("Gains potentiels nets :", style: TextStyle(color: Colors.white54)),
            Text("${gainEstimeMois.toInt()} € / mois", style: const TextStyle(color: Colors.cyan, fontSize: 36, fontWeight: FontWeight.bold)),
            
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: () => setState(() => afficherResultat = false),
              icon: const Icon(Icons.edit, color: Colors.cyan),
              label: const Text("Modifier mes informations", style: TextStyle(color: Colors.cyan)),
            ),
          ],
        ],
      ),
    );
  }
}
