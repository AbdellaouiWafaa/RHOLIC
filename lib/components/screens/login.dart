import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';
import 'package:RHOLIC/components/screens/documents.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:RHOLIC/components/screens/user_session.dart';

final backendBaseUrl = 'https://backendapp-production-3be4.up.railway.app';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ccpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ccpController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> saveUserInformation(Map<String, String> userInfo) async {
    final url = '$backendBaseUrl/api/create-account';
    debugPrint('Sending request to: $url');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userInfo),
    ).timeout(const Duration(seconds: 10));

    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Raw response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      try {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        throw Exception(error);
      } catch (e) {
        throw Exception('Unexpected response format: ${response.body}');
      }
    }
    return jsonDecode(response.body); // <-- Return the response data
  }

  void _validateAndContinue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userInfo = {
        'name': _nameController.text,
        'username': _usernameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'ccp': _ccpController.text,
      };

      saveUserInformation(userInfo)
          .then((responseData) {
            setState(() {
              _isLoading = false;
            });

            // Set user data globally
            UserData.setUserData(
              username: responseData['user']['username'],
              email: responseData['user']['email'],
              name: responseData['user']['name'],
              userId: responseData['user']['id'],
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UploadScreen()),
            );
          })
          .catchError((error) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving information: $error')),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment:

                       MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color.fromARGB(255, 165, 133, 36),
                            ),
                            onPressed: () {
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
                      const SizedBox(
                        height: 20,
                      ), // Spacing between arrows and "Create Account"
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
                      const SizedBox(
                        height: 2,
                      ), // Same spacing between "Create Account" and the container
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
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
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
                                          _buildTextField(
                                            "Name",
                                            _nameController,
                                          ),
                                          _buildTextField(
                                            "Username",
                                            _usernameController,
                                          ),
                                          _buildTextField(
                                            "Email",
                                            _emailController,
                                            isEmail: true,
                                          ),
                                          _buildTextField(
                                            "Phone number",
                                            _phoneController,
                                            isPhone: true,
                                          ),
                                          _buildTextField(
                                            "Address",
                                            _addressController,
                                          ),
                                          _buildTextField(
                                            "CCP account number",
                                            _ccpController,
                                            isPassword: true,
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFFC4A05D,
                                              ),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              minimumSize: const Size(
                                                double.infinity,
                                                50,
                                              ),
                                            ),
                                            onPressed: _validateAndContinue,
                                            child: Text(
                                              "Continue",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
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
              ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isPassword = false,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && hint != "CCP account number",
        keyboardType:
            isEmail
                ? TextInputType.emailAddress
                : isPhone
                ? TextInputType.phone
                : TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.black54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.pinkAccent),
          ),
          suffixIcon:
              isPassword && hint != "CCP account number"
                  ? const Icon(
                    Icons.visibility_off,
                    color: Color.fromARGB(255, 212, 133, 7),
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$hint cannot be empty";
          }
          if (isEmail && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return "Enter a valid email address";
          }
          if (isPhone && !RegExp(r'^\d+$').hasMatch(value)) {
            return "Enter a valid phone number";
          }
          return null;
        },
      ),
    );
  }
}