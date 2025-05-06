import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe_app/Admin_interfaces/login2.dart';
import 'package:pfe_app/components/screens/genre_select.dart';

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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/books_background.jpeg',
            fit: BoxFit.cover,
          ),

          // Side fade overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Color.fromRGBO(0, 0, 0, 0.6),
                ],
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
                                  builder: (context) =>
                                      const Login2()), 
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
                            "Admin",
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
                            "Reader",
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
    );
  }
}
