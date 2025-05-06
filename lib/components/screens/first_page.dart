import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/Admin_interfaces/login2.dart';
import 'package:RHOLIC/components/screens/genre_select.dart';

void main() {
  runApp(const FirstpageScreen());
}

class FirstpageScreen extends StatelessWidget {
  const FirstpageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FirstPageScreen(),
    );
  }
}

class FirstPageScreen extends StatelessWidget {
  const FirstPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/bib1.png'), // Assurez-vous que ce fichier est bien votre image de bibliothèque
            fit: BoxFit
                .cover, // Couvre tout l'espace disponible sans déformation excessive
          ),
        ),
        child: Stack(
          // Utiliser Stack pour superposer l'overlay et le contenu
          children: [
            // Optional: Superposition sombre pour un meilleur contraste du texte
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(
                    0.5), // Ajustez l'opacité au besoin (0.5 = 50% opaque)
              ),
            ),
            // Contenu (Titre et Boutons)
            SafeArea(
              // Utiliser SafeArea pour éviter les barres de statut et encoches
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Espacer le titre et les boutons
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Étirer les boutons horizontalement
                  children: [
                    // Titre
                    Expanded(
                      // Permet à la zone du titre de prendre l'espace restant
                      child: Center(
                        // Centre le titre dans la zone étendue
                        child: Text(
                          'RHOLIC Library', // Le titre de l'interface
                          textAlign: TextAlign.center,
                          style: GoogleFonts.islandMoments(
                            // Utilise la police Island Moments
                            fontSize: 60, // Ajustez la taille de la police
                            color: Colors.white, // Couleur du texte
                            fontWeight: FontWeight.w600, // Poids de la police
                          ),
                        ),
                      ),
                    ),
          // Buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Admin buttonNewUserScreen
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  Login2 (),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(255, 213, 79, 0.1),   // Left fade
                              Color.fromARGB(255, 165, 133, 20),   // Center
                              Color.fromRGBO(255, 213, 79, 0.1),   // Right fade
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Sign In as Admin",
                            style: GoogleFonts.playfairDisplay( // Apply Playfair Display font
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),

                    // Reader button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenreSelectionScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color.fromRGBO(0, 0, 0, 0.5),   // Left fade
                              Color.fromRGBO(0, 0, 0, 1.0),   // Center
                              Color.fromRGBO(0, 0, 0, 0.5),   // Right fade
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Continue As a Reader",
                            style: GoogleFonts.ebGaramond( // Apply EB Garamond font
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    )
            ),
          ]
        ))
    );
  }
}
