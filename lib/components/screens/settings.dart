import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/languages.dart'; // Assuming this path is correct
import 'package:RHOLIC/components/screens/notifications.dart'; // Assuming this path is correct
import 'package:share_plus/share_plus.dart'; // <-- Import share_plus

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E3F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          SettingsItem(
            icon: Icons.language,
            title: 'Languages',
            trailingText: 'English', // Consider making this dynamic based on actual selection
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageScreen(),
                ),
              );
            },
          ),
          SettingsItem(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          // --- Share App Item ---
          SettingsItem(
            icon: Icons.share,
            title: 'Share app',
            onTap: () {
            
            
              const String appLink = "https://your-app-store-link.com"; 
              const String shareMessage = "Check out this amazing app: $appLink";

              Share.share(
                shareMessage,
                subject: 'Check out this app!' // Optional: Used for email subject
              );
              // --- End of Share Logic ---
            },
          ),
          // --- End of Share App Item ---
         
        ],
      ),
    );
  }
}

// --- SettingsItem Widget (Remains the same) ---
class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingsItem({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 7),
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Color.fromARGB(215, 255, 255, 255), fontWeight: FontWeight.bold, fontSize: 20),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Padding( // Added padding for better spacing if text exists
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                trailingText!,
                style: const TextStyle(color: Color.fromARGB(255, 124, 124, 124), fontWeight: FontWeight.bold),
              ),
            ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
      onTap: onTap, // The onTap callback is passed here
    );
  }
}