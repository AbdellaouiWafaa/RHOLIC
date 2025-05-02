import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Importez les écrans pour les différentes sections depuis leurs fichiers respectifs
import 'manage_screen.dart';
import 'catalogue_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';

// Convertir en StatefulWidget
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0; // Index de l'élément sélectionné dans la NavBar
  // Contrôleur pour le TextField de recherche
  final TextEditingController _searchController = TextEditingController();
  // Variable pour suivre l'état de la recherche (activée ou non)
  bool _isSearching = false;

  // Liste des widgets à afficher pour chaque élément de la NavBar
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialiser les écrans ici
    _screens = [
      DashboardContent(), // Le contenu de votre tableau de bord actuel
      const ManageScreen(), // Importé depuis manage_screen.dart
      const CatalogueScreen(), // Importé depuis catalogue_screen.dart
      const ProfileScreen(), // Importé depuis profile_screen.dart
    ];
  }

  @override
  void dispose() {
    // Libérer le contrôleur à la fin du cycle de vie du widget
    _searchController.dispose();
    super.dispose();
  }

  // Méthode appelée lorsque l'on clique sur un élément de la NavBar
  void _onItemTapped(int index) {
    // Mettre à jour l'index sélectionné
    setState(() {
      _selectedIndex = index;
    });
    print('Bouton cliqué: $index'); // Log pour déboguer
  }

  // Méthode pour commencer la recherche
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
    // Cela va automatiquement afficher le clavier
  }

  // Méthode pour terminer la recherche
  void _endSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    // Cela cachera le clavier
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle appBarTitleStyle = GoogleFonts.montserrat(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121921),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A3B),
        elevation: 4.0,
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: _endSearch,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true, // Affiche automatiquement le clavier
                style:
                    GoogleFonts.montserrat(fontSize: 18, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: GoogleFonts.montserrat(
                      fontSize: 22, color: Colors.white.withOpacity(0.7)),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  // Traiter la recherche ici
                  print('Recherche: $value');
                  // Vous pouvez garder le mode recherche ou le désactiver
                  // _endSearch();
                },
              )
            : GestureDetector(
                onTap: _startSearch,
                child: Text('Search...', style: appBarTitleStyle),
              ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 28),
            onPressed: _startSearch,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFFB19E44), // Golden color
                size: 28,
              ),
              onPressed: () {
                print('Notifications tapped');
                // Navigation vers l'écran des notifications
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Le corps du Scaffold affiche maintenant l'écran sélectionné
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E2A3B),
        selectedItemColor:
            const Color(0xFFB19E44), // Couleur dorée quand sélectionné
        unselectedItemColor: Colors.white
            .withOpacity(0.7), // Couleur grise quand non sélectionné
        currentIndex:
            _selectedIndex, // Utilise l'index d'état pour déterminer l'onglet actif
        onTap: _onItemTapped, // Appelle la méthode pour changer d'écran
        type: BottomNavigationBarType
            .fixed, // Permet d'avoir plus de 3 items sans comportement de shifting
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Catalogue',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Voici la classe DashboardContent (que vous pouvez garder ici ou
// également déplacer dans un fichier séparé si nécessaire)
class DashboardContent extends StatelessWidget {
  DashboardContent({Key? key}) : super(key: key);

  // Déplacer les données et les styles de texte spécifiques au dashboard ici
  // Données depuis la maquette (kept user's data)
  final int borrowedCount = 305;
  final int overdueCount = 23;
  final int fineCollected = 15;
  final int newUsers = 2;
  final int inactiveUsers = 42;
  final int activeUsers = 1913;
  final int totalTitles = 103447;
  final int totalMembers = 1955;

  // Styles pour Welcome section (basique comme demandé pour Welcome/Jane)
  final TextStyle welcomeBackStyle = const TextStyle(
    fontSize: 32,
    color: Colors.white,
  );

  final TextStyle adminNameStyle = const TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 42,
    color: Colors.white70,
  );

  // Styles pour les cartes
  final TextStyle cardTitleStyle = GoogleFonts.islandMoments(
    fontSize: 36,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  final TextStyle statNumberStyle = GoogleFonts.montserrat(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  final TextStyle statLabelStyle = GoogleFonts.montserrat(
    fontSize: 20,
    color: Colors.white.withOpacity(0.7),
  );

  final TextStyle monthlyUsageStyle = GoogleFonts.montserrat(
    color: Colors.white.withOpacity(0.7),
    fontSize: 20,
    fontWeight: FontWeight.w300,
  );

  final TextStyle totalStatsStyle = GoogleFonts.montserrat(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w300,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section de bienvenue avec photo de profil (Centered)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage('assets/images/admin.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back,',
                          style: welcomeBackStyle), // Basic TextStyle
                      Text('Jane', style: adminNameStyle), // Basic TextStyle
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Carte statut bibliothèque
          _buildCard(
            'Library Stats',
            cardTitleStyle, // IslandMoments
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: LineChartPainter(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Monthly Usage',
                  style: monthlyUsageStyle, // IslandMoments
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$totalTitles Titles',
                        style: totalStatsStyle), // IslandMoments
                    Text('$totalMembers Members',
                        style: totalStatsStyle), // IslandMoments
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Carte statistiques d'emprunt
          _buildCard(
            'Borrow Stats',
            cardTitleStyle, // IslandMoments
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('$borrowedCount', 'Borrowed',
                      statNumberStyle, statLabelStyle), // IslandMoments styles
                  _buildStatColumn('$overdueCount', 'Overdue', statNumberStyle,
                      statLabelStyle), // IslandMoments styles
                  Column(
                    children: [
                      Text('$fineCollected',
                          style: statNumberStyle), // IslandMoments
                      Text('Fine', style: statLabelStyle), // IslandMoments
                      Text('Collected', style: statLabelStyle), // IslandMoments
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Carte statistiques utilisateurs
          _buildCard(
            'User Stats',
            cardTitleStyle, // IslandMoments
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('$newUsers',
                          style: statNumberStyle), // IslandMoments
                      Text('New', style: statLabelStyle), // IslandMoments
                      Text('Users', style: statLabelStyle), // IslandMoments
                    ],
                  ),
                  Column(
                    children: [
                      Text('$inactiveUsers',
                          style: statNumberStyle), // IslandMoments
                      Text('Inactive', style: statLabelStyle), // IslandMoments
                      Text('Users', style: statLabelStyle), // IslandMoments
                    ],
                  ),
                  Column(
                    children: [
                      Text('$activeUsers',
                          style: statNumberStyle), // IslandMoments
                      Text('Active', style: statLabelStyle), // IslandMoments
                      Text('Users', style: statLabelStyle), // IslandMoments
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Helper methods are part of this widget now
  Widget _buildCard(String title, TextStyle titleStyle, Widget content) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2A3B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
      String value, String label, TextStyle valueStyle, TextStyle labelStyle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: valueStyle),
        Text(label, style: labelStyle),
      ],
    );
  }
}

// Peintre personnalisé pour le graphique linéaire
class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFFB19E44) // Golden line color from Figma
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = const Color(0xFFB19E44) // Golden points
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    final Paint fillPaint = Paint() // Paint for the area under the line
      ..color = const Color(0xFFB19E44)
          .withOpacity(0.2) // Semi-transparent golden fill
      ..style = PaintingStyle.fill;

    // Définition des points pour le graphique linéaire (example data)
    final List<Offset> points = [
      Offset(size.width * 0, size.height * 0.7),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.5),
      Offset(size.width * 1.0, size.height * 0.4),
    ];

    final Path path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final Path filledPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(filledPath, fillPaint);
    canvas.drawPath(path, linePaint);

    for (final Offset point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }

    final Paint axisPaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(points.first.dx, size.height),
        Offset(points.last.dx, size.height), axisPaint);
    canvas.drawLine(Offset(points.first.dx, size.height),
        Offset(points.first.dx, 0), axisPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
