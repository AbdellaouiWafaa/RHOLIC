import 'package:RHOLIC/user_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/personnel_infos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String backendBaseUrl =
    'https://backendapp-production-3be4.up.railway.app';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  int? userId;
  String selectedCountry = 'Algeria';
  String countryCode = '+213';
  String countryFlag = '🇩🇿';

  final Map<String, String> countryData = {
    'Algeria': '+213',
    'Morocco': '+212',
    'Tunisia': '+216',
  };

  final Map<String, String> countryFlags = {
    'Algeria': '🇩🇿',
    'Morocco': '🇲🇦',
    'Tunisia': '🇹🇳',
  };

  String selectedGender = 'Female';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isLoading = false;

  Future<void> submitData() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$backendBaseUrl/api/update-profile');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'fullName': nameController.text,
          'nickName': usernameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'country': selectedCountry,
          'gender': selectedGender,
          'address': addressController.text,
        }),
      );

      // Debug print for status code and response body
      debugPrint('Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $error')),
        );
      }
    } catch (error) {
      print('Exception: $error');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userId = UserData.userId; // Get it automatically
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    if (userId == null) return;
    final url = Uri.parse('$backendBaseUrl/api/user/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        setState(() {
          nameController.text = user['name'] ?? '';
          usernameController.text = user['username'] ?? '';
          emailController.text = user['email'] ?? '';
          phoneController.text = user['phone'] ?? '';
          addressController.text = user['address'] ?? '';
          selectedGender = user['gender'] ?? 'Female';
          selectedCountry = user['country'] ?? 'Algeria';
        });
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F3A),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  builder:
                                      (context) =>
                                          const ProfileSettingsScreen(),
                                ),
                              );
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "Edit profile",
                                style: GoogleFonts.poppins(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildInputField("Full name", "", nameController),
                      buildInputField("Nick name", "", usernameController),
                      buildInputField(
                        "Email",
                        "xxxxxxxxxxx@gmail.com",
                        emailController,
                      ),
                      buildPhoneField(phoneController),
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdown(
                              "Country",
                              ['Algeria', 'Morocco', 'Tunisia'],
                              selectedCountry,
                              (value) {
                                setState(() {
                                  selectedCountry = value;
                                  countryCode = countryData[value]!;
                                  countryFlag = countryFlags[value]!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: buildDropdown(
                              "Gender",
                              ['Male', 'Female'],
                              selectedGender,
                              (value) => setState(() => selectedGender = value),
                            ),
                          ),
                        ],
                      ),
                      buildInputField(
                        "Address",
                        "80 rue national, Algeria",
                        addressController,
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: submitData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              56,
                              152,
                              254,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "SUBMIT",
                            style: GoogleFonts.poppins(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0A0F3A),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Extra padding at bottom
                    ],
                  ),
                ),
              ),
    );
  }

  Widget buildInputField(
    String label,
    String value,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color.fromARGB(242, 240, 240, 240),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white),
            ),
            hintText: value,
            hintStyle: const TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildPhoneField(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone number", style: GoogleFonts.poppins(color: Colors.white70)),
        const SizedBox(height: 5),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                countryFlag,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: countryCode,
                  hintStyle: const TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.white70)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              dropdownColor: const Color(0xFF0A0F3A),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              style: const TextStyle(color: Colors.white),
              onChanged: (value) => onChanged(value!),
              items:
                  items.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}