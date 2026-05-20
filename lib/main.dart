import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool showResults = false;
  
  String sexe = "Homme", ossature = "Fine", focus = "Bras";
  int age = 20, poids = 75, taille = 180, reveil = 8, eauActuelle = 2;

  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/vxshare5/249');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchEquipment() async {
    final Uri url = Uri.parse('https://www.amazon.fr/s?k=materiel+musculation+maison');
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  void _showHelpDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1C1C1E),
      title: const Text("Help", style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text("Version: 0.0.1\n\n[ Petit rappel: Les données ne sont jamais enregistrer, donc quand vous quittez l'appli, elles sont effacer. ]", style: TextStyle(color: Colors.white54)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _launchTelegram, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF24A1DE),
          ),
          child: const Text(
            "Rejoindre le groupe", 
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    ),
  );
}

  Map<String, String> _getRepasPourJour(String jour) {
    bool isPriseDeMasse = poids < 78;

    if (jour == "Lundi" || jour == "Jeudi") {
      return {
        "plat": isPriseDeMasse 
            ? "Pâtes complètes, steak haché 5%, sauce tomate maison, olives noires et parmesan."
            : "Pavé de saumon, quinoa, brocolis vapeur, filet d'huile d'olive et citrons.",
        "dessert": "Banane et une poignée d'amandes (Riche en potassium et magnésium).",
        "collation": "3 œufs au plat avec une tranche de pain de seigle."
      };
    } else if (jour == "Mardi" || jour == "Vendredi") {
      return {
        "plat": isPriseDeMasse 
            ? "Riz basmati, émincé de poulet, crème de coco, curry et avocat entier."
            : "Blanc de dinde, patate douce au four, asperges et filet d'huile de colza.",
        "dessert": "Une grosse orange (Idéal pour faire le plein de Vitamine C).",
        "collation": "Bol de fromage blanc 3% avec du miel et des graines de chia."
      };
    } else if (jour == "Mercredi" || jour == "Samedi") {
      return {
        "plat": isPriseDeMasse
            ? "Wrap complet au thon, œufs durs écrasés, tomates, maïs et filet d'huile d'olive."
            : "Salade de lentilles vertes, pavé de cabillaud, tomates cerises et olives vertes.",
        "dessert": "Pomme coupée en morceaux avec un carré de chocolat noir 85%.",
        "collation": "Smoothie maison : Lait d'amande, beurre de cacahuète et flocons d'avoine."
      };
    } else {
      return {
        "plat": "Riz cantonais revisité (Riz, petits pois, dés de jambon, œufs brouillés) et salade verte.",
        "dessert": "Un bol de fraises ou de baies rouges (Antioxydants puissants).",
        "collation": "Une poignée de noix de Grenoble et un thé vert."
      };
    }
  }

  void _showCalendarSheet() {
    final List<String> jours = ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"];
    String timing = poids > 80 ? "Après le sport (Fenêtre Anabolique)" : "Avant le sport (Glucides complexes)";

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ALIMENTATION SEMAINE", style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: jours.length,
                itemBuilder: (context, index) {
                  String jour = jours[index];
                  Map<String, String> nutritionJour = _getRepasPourJour(jour);
                  
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 15, bottom: 10),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white10)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(jour, style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold)),
                          const Divider(color: Colors.white10, height: 25),
                          
                          Row(children: [
                            Icon(Icons.fitness_center, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            const Text("SÉANCE DU JOUR", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 6),
                          Text(jour == "Dimanche" ? "Repos complet" : "$focus Intensif", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          
                          const SizedBox(height: 20),
                          Row(children: [
                            Icon(Icons.restaurant, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            const Text("PLAT PRINCIPAL", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 6),
                          Text(nutritionJour["plat"]!, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                          
                          const SizedBox(height: 20),
                          Row(children: [
                            Icon(Icons.apple, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            const Text("DESSERT VITAMINÉ", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 6),
                          Text(nutritionJour["dessert"]!, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),
                          
                          const SizedBox(height: 20),
                          Row(children: [
                            Icon(Icons.cookie, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            const Text("COLLATION DU JOUR", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 6),
                          Text(nutritionJour["collation"]!, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4)),

                          const SizedBox(height: 20),
                          Row(children: [
                            Icon(Icons.access_time, color: Colors.white54, size: 16),
                            const SizedBox(width: 8),
                            const Text("TIMING REPAS", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                          ]),
                          const SizedBox(height: 6),
                          Text(timing, style: const TextStyle(color: Colors.amber, fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: Column(children: [
      Padding(padding: const EdgeInsets.all(25), child: Row(children: [
        if (etape > 0 && !showResults) IconButton(onPressed: () => setState(() => etape--), icon: const Icon(Icons.arrow_back_ios, color: Colors.white)),
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset('assets/app_icon.png', width: 40, height: 40)),
        const SizedBox(width: 15),
        const Text("VIP FIT", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
        const Spacer(),
        IconButton(icon: const Icon(Icons.help_outline, color: Colors.amber, size: 30), onPressed: _showHelpDialog)
      ])),
      Expanded(child: showResults ? _buildResults() : _buildStepper()),
    ]));
  }

  Widget _buildStepper() {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _getStepContent(),
      const Spacer(),
      SizedBox(width: double.infinity, height: 60, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () => setState(() => etape < 7 ? etape++ : showResults = true),
        child: Text(etape == 7 ? "VOIR MON PLAN" : "CONTINUER", style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
      )),
      const SizedBox(height: 30)
    ]));
  }

  Widget _buildResults() {
    String timing = poids > 80 ? "Après le sport (Insuline)" : "Avant le sport (Énergie)";
    Map<String, String> nutritionAujourdhui = _getRepasPourJour("Lundi");
    
    return ListView(padding: const EdgeInsets.all(25), children: [
      const Text("VOTRE PLAN", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
      const SizedBox(height: 25),

      GestureDetector(
        onTap: _showCalendarSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_month, color: Colors.black, size: 24),
              const SizedBox(width: 12),
              const Text("CALENDRIER DES REPAS", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),

      _sectionIntuitive("A FAIRE", Icons.water_drop, [
        _infoBouton("Eau en plus a boire :", "${((poids * 0.035) - eauActuelle).clamp(0, 5).toStringAsFixed(1)} L"),
        _infoBouton("Noix ou cacahuètes non salés :", "${(poids * 0.4).toInt()} g"),
      ]),

      _sectionIntuitive("REPAS SAIN", Icons.restaurant_menu, [
        _infoTextBloque("Plat sain & complet", nutritionAujourdhui["plat"]!),
        _infoTextBloque("Fruits & Énergie (Dessert)", nutritionAujourdhui["dessert"]!),
        _infoBouton("Timing idéal :", timing),
      ]),
      
      _sectionIntuitive("PLAN SPORTIF ($focus)", Icons.fitness_center, [
        _infoBouton("Repos requis :", ossature == "Fine" ? "3 minutes" : "2 minutes"),
        _infoBouton("Exercice clé :", "Farmer Walk"),
      ]),

      _sectionIntuitive("MATÉRIEL MAISON", Icons.gavel, [
        GestureDetector(
          onTap: _launchEquipment,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.3), width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Équipement a la maison", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Icon(Icons.open_in_new, color: Colors.amber, size: 18),
              ],
            ),
          ),
        ),
      ]),
      
      const SizedBox(height: 25),
      Center(child: TextButton(onPressed: () => setState(() {showResults = false; etape = 7;}), child: const Text("Modifier mes infos", style: TextStyle(color: Colors.white30, fontSize: 16))))
    ]);
  }

  Widget _sectionIntuitive(String title, IconData icon, List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 15),
    child: ExpansionTile(
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
      backgroundColor: const Color(0xFF1C1C1E),
      collapsedBackgroundColor: const Color(0xFF1C1C1E),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      childrenPadding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
      children: children,
    ),
  );

  Widget _infoBouton(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 15))),
        Text(value, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    ),
  );

  Widget _infoTextBloque(String title, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.amber, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.3)),
      ],
    ),
  );

  Widget _getStepContent() {
    final steps = [
      _field("Ton sexe ?", _chips(["Homme", "Femme"], sexe, (v) => setState(() => sexe = v))),
      _field("Quel est ton age ?", _ctrl(age, (v) => setState(() => age = v))),
      _field("Combien tu pèse ?", _ctrl(poids, (v) => setState(() => poids = v))),
      _field("Quel Taille tu fait ?", _ctrl(taille, (v) => setState(() => taille = v))),
      _field("Tu dort combien d'heures ?", _ctrl(reveil, (v) => setState(() => reveil = v))),
      _field("Combien de litre d'eau tu bois par jour (environ) ?", _ctrl(eauActuelle, (v) => setState(() => eauActuelle = v))),
      _field("Tu as des os plutôt fins ou épais ?", _chips(["Fine", "Normale"], ossature, (v) => setState(() => ossature = v))),
      _field("Quel est ton objectif ?", _chips(["Bras", "Jambes", "Dos"], focus, (v) => setState(() => focus = v))),
    ];
    return steps[etape];
  }

  Widget _field(String label, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)), 
    const SizedBox(height: 25), 
    child
  ]);

  Widget _ctrl(int v, Function(int) f) => Row(children: [
    IconButton(onPressed: () => f(v-1), icon: const Icon(Icons.remove_circle, color: Colors.amber, size: 45)), 
    Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text("$v", style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold))), 
    IconButton(onPressed: () => f(v+1), icon: const Icon(Icons.add_circle, color: Colors.amber, size: 45))
  ]);

  Widget _chips(List<String> items, String current, Function(String) f) => Wrap(spacing: 12, runSpacing: 12, children: items.map((e) => ChoiceChip(
    label: Text(e, style: TextStyle(fontSize: 16, color: current == e ? Colors.black : Colors.white)),
    selected: current == e, onSelected: (_) => f(e), selectedColor: Colors.amber, backgroundColor: const Color(0xFF1C1C1E),
  )).toList());
}