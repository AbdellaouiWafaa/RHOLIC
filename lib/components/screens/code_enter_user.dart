import 'package:RHOLIC/components/screens/genre_select.dart';
import 'package:RHOLIC/components/screens/password_reset.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/book_details.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';

const String backendBaseUrl = 'https://backendapp-production-3be4.up.railway.app';

class OtpuserScreen extends StatefulWidget {
  const OtpuserScreen({super.key});

  @override
  State<OtpuserScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpuserScreen> {
  final TextEditingController _otpController = TextEditingController();
  String enteredOtp = '';

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (enteredOtp == '12348') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => getAliceInWonderlandDetailsScreen(),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid verification code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 165, 133, 36),
            size: 30,
          ),
          onPressed: () {
            
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenreSelectionScreen(),
                      ),
                    );
                  
          },
        ),
        title: Text(
          'Sign In',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 190),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 20),

                    // Text input instead of OTP
                    TextField(
                      controller: _otpController,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Enter verification code",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: Colors.white10,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 165, 133, 36),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 165, 133, 36),
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          enteredOtp = text;
                        });
                        debugPrint("Text entered: $text");
                      },
                    ),

                    const SizedBox(height: 15),
                    // Resend Text
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forget your code? Click here",
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 165, 133, 36),
                          fontSize: 17,),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromARGB(255, 165, 133, 36),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Color.fromARGB(255, 165, 133, 36),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                165,
                                133,
                                36,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "Verify",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}