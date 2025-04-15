import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe_app/components/screens/personnel_infos.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EditProfileScreen(),
  ));
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  String selectedCountry = 'Algeria';
  String countryCode = '+213'; // Default country code
  String countryFlag = '🇩🇿'; // Default flag

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F3A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileSettingsScreen(),
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
            buildInputField("Full name", "Ahlem Boudaoud"),
            buildInputField("Nick name", "Dream"),
            buildInputField("Label", "xxxxxxxxxxx@gmail.com"),
            buildPhoneField(),
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
                const SizedBox(width: 10),
                Expanded(
                  child: buildDropdown(
                    "Genre",
                    ['Male', 'Female'],
                    selectedGender,
                    (value) => setState(() => selectedGender = value),
                  ),
                ),
              ],
            ),
            buildInputField("Address", "80 rue national, Algeria"),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 56, 152, 254),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
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
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: const Color.fromARGB(242, 240, 240, 240))),
        const SizedBox(height: 5),
        TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent, // Transparent background
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.white), // White border
            ),
            hintText: value,
            hintStyle: const TextStyle(color: Colors.white70), // Semi-transparent hint text
          ),
          style: const TextStyle(color: Colors.white), // Text color
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildPhoneField() {
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
              child: Text(countryFlag, style: const TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
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

  Widget buildDropdown(String label, List<String> items, String selectedValue, Function(String) onChanged) {
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
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.poppins(color: Colors.white)),
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
