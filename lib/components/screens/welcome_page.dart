import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/first_page.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A30), 
      body: Padding(
        padding: const EdgeInsets.only(top: 170.0), 
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              // Logo
              Image.asset(
                "assets/images/both.png", // Replace with your logo path
                height: 250,
              ),
              const SizedBox(height: 0), // Reduced space between logo and text
              // Subtitle
              RichText(
                text: TextSpan(
                  text: 'Welcome, ',
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontFamily: 'Inter',
                   
                  ),
                  children: [
                    TextSpan(
                      text: 'Readaholic!',
                      style: TextStyle(
                        fontSize: 22,
                        color: const Color.fromARGB(255, 165, 133, 36), // Gold color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' Let’s Get Starting',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                   
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 270), 
              
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstpageScreen(), 
                    ),
                  );
                },
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FirstpageScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 165, 133, 36), // Gold color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
