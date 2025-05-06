import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/login.dart';


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ResetPasswordScreen(),
  ));
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },
                ),
                
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Reset password",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 90),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Email",
                hintStyle: const TextStyle(color: Color.fromARGB(178, 94, 94, 94)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.visibility, color: Color.fromARGB(178, 94, 94, 94)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              icon: Image.asset(
                "assets/images/Google__G__logo.svg.png",
                height: 24,
                width: 24,
              ),
              label: const Text(
                "Continue with Google",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  color: Color.fromARGB(178, 94, 94, 94),
                ),
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color.fromARGB(255, 165, 133, 36)),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Reset password",
                style: TextStyle(
                  color: Color.fromARGB(255, 165, 133, 36),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}