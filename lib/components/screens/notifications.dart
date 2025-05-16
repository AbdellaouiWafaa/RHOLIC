import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  NotificationSettingsScreenState createState() => NotificationSettingsScreenState();
}

class NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  Map<String, bool> settings = {
    "General Notification": false,
    "Sound": false,
    "Vibrate": true,
    "App updates": false,
    "Bill Reminder": true,
    "Promotion": true,
    "Discount Available": false,
    "Payment Request": false,
    "New Service Available": false,
    "New Tips Available": true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F3A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Notifications",
                        style: GoogleFonts.poppins(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Placeholder to balance the space for the back button
                ],
              ),
              const SizedBox(height: 20),
              // Wrap everything below the header in Expanded and SingleChildScrollView
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSection("Common"),
                      buildToggle("General Notification"),
                      buildToggle("Sound"),
                      buildToggle("Vibrate"),
                      const Divider(color: Colors.white24),
                      buildSection("System & services update"),
                      buildToggle("App updates"),
                      buildToggle("Bill Reminder"),
                      buildToggle("Promotion"),
                      buildToggle("Discount Available"),
                      buildToggle("Payment Request"),
                      const Divider(color: Colors.white24),
                      buildSection("Others"),
                      buildToggle("New Service Available"),
                      buildToggle("New Tips Available"),
                      // Add some bottom padding for better scrolling experience
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildToggle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1), // Reduced vertical padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 16, color: const Color.fromARGB(236, 255, 255, 255)),
          ),
          SwitchTheme(
            data: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF4A4A4A); // Dark grey thumb color when active
                  }
                  return const Color(0xFF4A4A4A); // Dark grey thumb color when inactive
                },
              ),
              trackColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(0xFF4A90E2); // Blue background when active
                  }
                  return const Color.fromARGB(255, 137, 137, 137); // Light grey background when inactive
                },
              ),
            ),
            child: Transform.scale(
              scale: 0.8, // Adjust the scale to make the thumb smaller
              child: Switch(
                value: settings[title]!,
                onChanged: (bool value) {
                  setState(() {
                    settings[title] = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}