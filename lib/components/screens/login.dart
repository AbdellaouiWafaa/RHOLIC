import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe_app/components/screens/code_enter.dart';
import 'package:pfe_app/components/screens/dashboard.dart';
import 'package:pfe_app/components/screens/documents.dart';
import 'package:pfe_app/components/screens/password_reset.dart';


class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32), // Dark blue background
      body: 
      Padding(
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
                  onPressed: ()  {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardScreen(),
                                  ),
                                );
                              },
                ),
              ],
            ),
            const SizedBox(height: 20), // Spacing between arrows and "Create Account"
            Center(
              child: Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  
                ),
              ),
            ),
            const SizedBox(height: 2), // Same spacing between "Create Account" and the container
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildTextField("Name"),
                                _buildTextField("Username"),
                                _buildTextField("Email"),
                                _buildTextField("Phone number"),
                                _buildTextField("CCP number account", isPassword: true),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC4A05D), // Gold color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    minimumSize: const Size(double.infinity, 50),
                                  ),
                                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadScreen(),
                      ),
                    );
                  },
                                  child: Text(
                                    "Continue",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 19),
                                Row(
                                  children: [
                                    const Expanded(child: Divider(color: Colors.black)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        "or",
                                        style: GoogleFonts.poppins(
                                          fontSize: 17,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: Divider(color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildGoogleButton(),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "you have account ?",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OtpScreen(),
                                  ),
                                );
                              },
                                      child: Text(
                                        " sign in",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: const Color.fromARGB(255, 198, 120, 2),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ResetPasswordScreen(),
                                  ),
                                );
                              },
                                  child: Text(
                                    "forgot your password",
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 198, 120, 2),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.pinkAccent),
          ),
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off,
                  color: Color.fromARGB(255, 212, 133, 7))
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Google__G__logo.svg.png",
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          Text(
            "Continue with Google",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ],
      ),
    );
  }
}