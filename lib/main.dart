import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/welcome_page.dart';



void main() {
  runApp(const ReadaholicApp());
}

class ReadaholicApp extends StatelessWidget {
  const ReadaholicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readaholic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter', 
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}