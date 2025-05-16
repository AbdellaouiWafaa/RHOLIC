import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E3F),
        title: const Text(
          'Language', // Static title
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Only Avaible', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 25)),
          ),
          // Example of suggested languages (no language switching)
          ListTile(
            title: const Text('English (US)', style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            title: const Text('English (UK)', style: TextStyle(color: Colors.white)),
          ),
          const Divider(color: Colors.grey),

        ],
      ),
    );
  }
}
