import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_app/components/screens/code_enter.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final String paymentCode = "123-ABC-456";
  final String mapsUrl = "https://maps.app.goo.gl/oKo7S2rS1sTKQZoL6";

  bool showCodeBar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            _buildUploadButton("If you are a student", "Upload here"),
            const SizedBox(height: 40),
            _buildUploadButton("If you are a worker", "Upload here"),
            const SizedBox(height: 120),

            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                disabledBackgroundColor: const Color.fromARGB(255, 20, 97, 173),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const SizedBox(
                height: 60,
                width: 180,
                child: Center(
                  child: Text("PAYMENT WAYS :", style: TextStyle(color: Colors.white70, fontSize: 22)),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Google Maps row
            _buildClickableRow(
              icon: Icons.place,
              title: "Please visit our library location",
              linkText: "here",
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(mapsUrl))) {
                  await launchUrl(Uri.parse(mapsUrl));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Could not open Google Maps")),
                  );
                }
              },
            ),

            const SizedBox(height: 20),

            // Show code row and trigger visibility
            _buildClickableRow(
              icon: Icons.credit_card_outlined,
              title: "Our code to send money",
              linkText: "here",
              onTap: () {
                setState(() {
                  showCodeBar = true;
                });
              },
            ),

            const SizedBox(height: 10),

            // Only show this if user clicked 'here'
            if (showCodeBar)
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: paymentCode));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Code copied to clipboard!"),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 20, 30, 80),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromARGB(255, 165, 133, 36), width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        paymentCode,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 165, 133, 36),
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.copy, color: Color.fromARGB(255, 165, 133, 36)),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Done button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the new screen when "Done" is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(), // Replace with your actual screen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text("Done", style: TextStyle(fontSize: 22, color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(String title, String buttonText) {
    return Row(
      children: [
        const Icon(Icons.upload_file, color: Colors.lightBlue),
        const SizedBox(width: 30),
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 25)),
        ),
        TextButton(
          onPressed: () {},
          child: Text(buttonText, style: const TextStyle(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Widget _buildClickableRow({
    required IconData icon,
    required String title,
    required String linkText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 20),
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(linkText, style: const TextStyle(color: Colors.lightBlue, fontSize: 16)),
        ),
      ],
    );
  }
}

// Replace `NextScreen` with your actual target screen
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text("Next Screen", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}