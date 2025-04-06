import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/genre_select.dart';



void main() {
  runApp(FirstpageScreen());
}

class FirstpageScreen extends StatelessWidget {
  const FirstpageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPageScreen(),
    );
  }
}

class FirstPageScreen extends StatelessWidget {
  const FirstPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/books_background.jpeg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 60),
                      ),
                      child: Text(
                        "ADMIN",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const GenreSelectionScreen(),
                ),
              );},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 165, 133, 36),
                        minimumSize: Size(double.infinity, 60),
                      ),
                      child: Text(
                        "READER",
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
