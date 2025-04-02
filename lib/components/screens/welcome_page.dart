import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050A30), // Dark blue background
      body: Padding(
        padding: const EdgeInsets.only(top: 170.0), // Adjust the top padding
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align content to the top
            children: [
              // Logo
              Image.asset(
                'C:\\Users\\thinkpad E14\\OneDrive\\Bureau\\pfe_app\\assets\\images\\both.png', // Replace with your logo path
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
                      text: ' Let’s Get Reading',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                   
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 300), // Space between text and icon
              // Navigation Icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(), // Replace with your next page
                    ),
                  );
                },
                child: const Icon(
                  Icons.arrow_forward, // Forward arrow icon
                  color: Color.fromARGB(255, 165, 133, 36),
                  size: 40, // Icon size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
