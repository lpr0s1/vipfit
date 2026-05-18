import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(backgroundColor: Color(0xFF0A0E17), body: WealthVisionPro())));

class WealthVisionPro extends StatefulWidget {
  const WealthVisionPro({super.key});
  @override
  State<WealthVisionPro> createState() => _WealthVisionProState();
}

class _WealthVisionProState extends State<WealthVisionPro> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Données utilisateur
  double salaire = 2500;
  double age = 30;
  String secteurInput = "75"; // Département ou Ville
  String businessType = "Achat de Box"; // Options: Achat de Box, Location de Box, Container Maritime

  // Logique métier simplifiée
  bool get isZoneVerte {
    // Simulation simple : les départements d'Île-de-France ou grandes villes (75, 92, 69, 13) sont en zone verte (forte demande)
    final sec = secteurInput.trim();
    return sec == "75" || sec == "92" || sec == "69" || sec == "13" || sec.toLowerCase() == "paris" || sec.toLowerCase() == "lyon";
  }

  double get capaciteEmprunt => salaire * 0.35;

  double get probaReussite {
    double base = isZoneVerte ? 85.0 : 45.0;
    if (businessType == "Container Maritime") base -= 10.0; // Plus dur d'obtenir l'autorisation terrain
    if (age < 21 || age > 60) base -= 15.0;
    return base.clamp(0.0, 100.0);
  }

  double get gainEstimeMois {
    double multiplicateur = isZoneVerte ? 1.2 : 0.7;
    if (businessType == "Location de Box") return (capaciteEmprunt / 100) * 45 * multiplicateur; // Sous-location / Conciergerie
    if (businessType == "Container Maritime") return (capaciteEmprunt / 250) * 160 * multiplicateur; // Plus gros volumes
    return (capaciteEmprunt / 150) * 110 * multiplicateur; // Achat Box classique
  }

  void _reset() {
    setState(() {
      salaire = 2500;
      age = 30;
      secteurInput = "75";
      businessType = "Achat de Box";
    });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Barre de navigation / Indicateur du haut
          Padding(
            padding: const EdgeInsets.all(16.0),
            additions: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentPage,
              selectedItemColor: Colors.cyan,
              unselectedItemColor: Colors.white30,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
                BottomNavigationBarItem(icon: Icon(Icons.map), label: "Secteur"),
                BottomNavigationBarItem(icon: Icon(Icons.business), label: "Projet"),
                BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analyse"),
              ],
            ),
          ),

          // Contenu des Vues (Vue par Vue)
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                // VUE 1 : Profil Financier
                _buildPage(
                  title: "Votre Profil",
                  child: Column(
                    children: [
                      Text("Âge : ${age.toInt()} ans", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Slider(value: age, min: 18, max: 75, activeColor: Colors.cyan, onChanged: (v) => setState(() => age = v)),
                      const SizedBox(height: 20),
                      Text("Salaire Mensuel : ${salaire.toInt()} €", style: const TextStyle(color: Colors.white, fontSize: 16)),
                      Slider(value: salaire, min: 1200, max: 7000, activeColor: Colors.cyan, onChanged: (v) => setState(() => salaire = v)),
                    ],
                  ),
                ),

                // VUE 2 : Secteur / Ville
                _buildPage(
                  title: "Votre Secteur",
                  child: Column(
                    children: [
                      const Text("Entrez votre département (ex: 75) ou grande ville :", style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Ex: 75 ou Paris",
                          hintStyle: const TextStyle(color: Colors.white24),
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
                        ),
                        onChanged: (v) => setState(() => secteurInput = v),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isZoneVerte ? "Secteur Validé : Zone VERTE (Forte demande)" : "Alerte Secteur : Zone ROUGE (Marché plus difficile)",
                        style: TextStyle(color: isZoneVerte ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                        textAlign: Center,
                      ),
                    ],
                  ),
                ),

                // VUE 3 : Type de Business
                _buildPage(
                  title: "Type de Business",
                  child: Column(
                    children: ["Achat de Box", "Location de Box", "Container Maritime"].map((type) {
                      return RadioListTile<String>(
                        title: Text(type, style: const TextStyle(color: Colors.white)),
                        value: type,
                        groupValue: businessType,
                        activeColor: Colors.cyan,
                        onChanged: (v) => setState(() => businessType = v!),
                      );
                    }).toList(),
                  ),
                ),

                // VUE 4 : Résultats & Calculs de Probabilités
                _buildPage(
                  title: "Analyse Finale",
                  child: Column(
                    children: [
                      Text("Capacité d'emprunt : ${capaciteEmprunt.toInt()} € / mois", style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 12),
                      Text("Probabilité de succès : ${probaReussite.toInt()}%", style: TextStyle(color: probaReussite > 50 ? Colors.greenAccent : Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Text("Gains Potentiels Estimés :", style: const TextStyle(color: Colors.white54)),
                      Text("${gainEstimeMois.toInt()} € / mois", style: const TextStyle(color: Colors.cyan, fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.2), side: const BorderSide(color: Colors.redAccent)),
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        label: const Text("Réinitialiser / Modifier", style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bouton d'action inférieur (Suivant / Retour automatique)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0)
                  TextButton(
                    onPressed: () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                    child: const Text("RETOUR", style: TextStyle(color: Colors.white54)),
                  )
                else
                  const SizedBox(),
                if (_currentPage < 3)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                    child: const Text("SUIVANT", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPage({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}
