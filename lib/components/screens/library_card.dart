import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/user_data.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController(); 

    return Scaffold(
      backgroundColor: const Color.fromARGB(121, 32, 46, 172),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(121, 32, 46, 172),
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(
          'Your Card',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
         centerTitle: true,
        actions: [
         
          
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SizedBox(
            width: double.infinity,
            height: 750,
            child: Column(
              children: [
                Expanded(
                  flex: 1, 
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: RotatedBox( 
                      quarterTurns: 3,
                      child: Column( 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50, 
                            backgroundColor: Color.fromARGB(255, 0, 0, 0),
                            child: Icon(Icons.person, size: 80, color: Color.fromARGB(255, 0, 0, 0)), // Increased icon size
                          ),
                          const SizedBox(height: 15),
                          Text(
                            (UserData.name ?? 'Your Name'),
                            style: GoogleFonts.ebGaramond( 
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          QrImageView(
                            data: "https://example.com", // Replace with actual data
                            version: QrVersions.auto,
                            size: 120.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2, // Adjusted flex to make the black background bigger
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: RotatedBox( // Rotates the content 90 degrees to the left
                      quarterTurns: 3,
                      child: SingleChildScrollView(
                        controller: scrollController, // Attach ScrollController
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                          children: [
                            GestureDetector(
                              onTap: () {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Image.asset(
                                'assets/images/both.png', 
                                width: 400, 
                                height: 400, 
                                fit: BoxFit.contain, 
                              ),
                            ),
                            const SizedBox(height: 40), 
                            GestureDetector(
                              onTap: () {
                                scrollController.animateTo(
                                  0, 
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: _buildInfoRow(Icons.phone_outlined, "05 58 13 88 09"),
                            ),
                            const SizedBox(height: 10), 
                            GestureDetector(
                              onTap: () {
                                scrollController.animateTo(
                                  0, 
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: _buildInfoRow(Icons.location_on, "13000 TLEMCEN    ALGERIA"),
                            ),
                            const SizedBox(height: 10), 
                            GestureDetector(
                              onTap: () {
                                scrollController.animateTo(
                                  0, 
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: _buildInfoRow(Icons.email_outlined, "RHOLIC@gmail.com"),
                            ),
                            const SizedBox(height: 130),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white,fontSize: 20)),
        ],
      ),
    );
  }
}