import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pfe_app/components/screens/notifications.dart';
import 'package:pfe_app/components/screens/password_reset.dart';
import 'package:pfe_app/components/screens/edit_profile.dart'; // Import the edit profile screen

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfileSettingsScreen(),
  ));
}

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A32),
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
                  onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    );},
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 165, 133, 36)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                child: const Icon(Icons.person, size: 40, color: Color(0xFF0A0F3A)),
              ),
            ),
            const SizedBox(height: 30),
            buildMenuItem(
              Icons.edit,
              "Edit profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(),
                  ),
                );
              },
            ),
            buildMenuItem(FontAwesomeIcons.palette, "Customizing interface"), // Replaced paintBrush with palette
            buildMenuItem(Icons.settings, "Setting"),
            const SizedBox(height: 20),
            buildMenuItem(
              FontAwesomeIcons.rightFromBracket, // Replaced signOutAlt with rightFromBracket
              "Log out",
              iconColor: Colors.red,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String text, {Color iconColor = Colors.white, Color textColor = Colors.white, Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 40),
                Text(
                  text,
                  style: GoogleFonts.poppins(fontSize: 20, color: textColor),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 165, 133, 36), size: 16),
          ],
        ),
      ),
    );
  }
}