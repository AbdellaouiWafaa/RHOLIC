import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login2.dart';

class Login1 extends StatelessWidget {
  const Login1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Rendre l'arrière-plan du Scaffold transparent pour montrer l'image du Container
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
                color: const Color(0x80000000), // 50% opacity black
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
                    // Colonne des boutons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Logique de navigation vers l'écran de connexion Admin (Login2)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Login2()), // Navigue vers Login2
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCC1E2A3B), // 80% opacity dark blue
                            foregroundColor:
                                Colors.white, // Couleur du texte des boutons
                            shape: const StadiumBorder(), // Forme de pilule
                            padding: const EdgeInsets.symmetric(
                                vertical:
                                    15), // Espacement interne vertical des boutons
                            textStyle: GoogleFonts.islandMoments(
                                fontSize: 32), // Style du texte du bouton
                          ),
                          child: const Text('Sign in as Admin'),
                        ),
                        const SizedBox(height: 15), // Espace entre les boutons
                        ElevatedButton(
                          onPressed: () {
                           
                            debugPrint('Continue as a Reader tapped');
                            // Exemple de navigation :
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xCC1E2A3B), // 80% opacity dark blue
                            foregroundColor:
                                Colors.white, // Couleur du texte des boutons
                            shape: const StadiumBorder(), // Forme de pilule
                            padding: const EdgeInsets.symmetric(
                                vertical:
                                    15), // Espacement interne vertical des boutons
                            textStyle: GoogleFonts.islandMoments(
                                fontSize: 32), // Style du texte du bouton
                          ),
                          child: const Text('Continue as a Reader'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}