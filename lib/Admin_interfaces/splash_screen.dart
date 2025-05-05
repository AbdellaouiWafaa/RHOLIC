import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Assurez-vous que ce fichier existe et contient la classe Login1
import 'login1.dart'; // Import the target screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late PageController _pageController;
  bool _showGetStarted = false;
  bool _showLogo = true;
  bool _showAppName = false;
  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Phase 1: Logo seul
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showLogo = true;
          _showAppName = false;
          _showWelcome = false;
        });
      }
    });

    // Phase 2: Logo + Nom de l'app
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showLogo = true;
          _showAppName = true;
          _showWelcome = false;
        });
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // Phase 3: Logo + Nom de l'app + Welcome
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _showLogo = true;
          _showAppName = true;
          _showWelcome = true;
        });
        _pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });

    // Afficher le bouton Get Started après un délai supplémentaire
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showGetStarted = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fond1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            // Premier écran - Logo seul
            Center(
              child: AnimatedOpacity(
                opacity: _showLogo ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  height: 140,
                  width: 140,
                ),
              ),
            ),

            // Deuxième écran - Logo + Nom de l'application
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Utiliser un Stack au lieu d'un Row pour un meilleur contrôle
                  SizedBox(
                    height: 180,
                    width:
                        360, // Une largeur fixe pour contenir les deux images
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Logo à gauche
                        Positioned(
                          left:
                              35, // Ajustez cette valeur pour positionner le logo
                          child: AnimatedOpacity(
                            opacity: _showLogo ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 800),
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              height: 140,
                              width: 140,
                            ),
                          ),
                        ),
                        // Nom de l'app à droite
                        Positioned(
                          right:
                              35, // Ajustez cette valeur pour positionner le texte
                          child: AnimatedOpacity(
                            opacity: _showAppName ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 700),
                            child: Image.asset(
                              'assets/images/rholic.png',
                              height: 160,
                              width: 240,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Troisième écran - Welcome + Logo + Nom de l'app
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Welcome text
                AnimatedOpacity(
                  opacity: _showWelcome ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    'Welcome to',
                    style: GoogleFonts.islandMoments(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        height: 1.3),
                  ),
                ),
                const SizedBox(height: 15),

                // Utiliser un Stack au lieu d'un Row
                SizedBox(
                  height: 160,
                  width: 320, // Largeur fixe pour contenir les deux images
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Logo à gauche
                      Positioned(
                        left:
                            20, // Ajustez cette valeur pour positionner le logo
                        child: AnimatedOpacity(
                          opacity: _showLogo ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            height: 140,
                            width: 140,
                          ),
                        ),
                      ),
                      // Nom de l'app à droite
                      Positioned(
                        right:
                            20, // Ajustez cette valeur pour positionner le texte
                        child: AnimatedOpacity(
                          opacity: _showAppName ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: Image.asset(
                            'assets/images/rholic.png',
                            height: 160,
                            width: 240,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedOpacity(
                    opacity: _showWelcome ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      'Discover a limitless world of reading, where every book brings you closer to a new adventure.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.islandMoments(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: _showGetStarted ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  child: GestureDetector(
                    onTap: () {
                      // Naviguer vers l'écran Login1 (AuthScreen)
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Login1()), // Navigue vers Login1
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical:
                              15), // Ajusté le padding pour un bouton plus large
                      decoration: BoxDecoration(
                        // Changed button color here back to golden
                        color: const Color(0xFFB19E44).withOpacity(
                            0.6), // Golden/brownish color like the logo
                        borderRadius:
                            BorderRadius.circular(30), // Kept rounded corners
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.islandMoments(
                          fontSize: 36, // Increased font size slightly
                          color: Colors.white, // Text color remains white
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // Indicateur de page retiré sur la dernière page
      bottomNavigationBar: _currentPage == 2
          ? null
          : Container(
              height: 20,
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // This is the page indicator, keeping it as is
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
