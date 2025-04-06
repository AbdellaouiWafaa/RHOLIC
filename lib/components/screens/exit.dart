import 'package:flutter/material.dart';

// Define colors for consistency (adjust if needed)
const Color _appBackgroundColor = Color(0xFF0A0E3F); // Dark blue background
const Color _iconCircleColor = Color(0xFF1C235E); // Slightly lighter blue for circle
const Color _primaryTextColor = Colors.white;
const Color _secondaryTextColor = Color(0xFFB0B3D1); // Lighter greyish blue for subtitle
const Color _buttonTextColorDark = Color(0xFF0A0E3F); // Dark text for white button

class ConfirmLogoutScreen extends StatelessWidget {
  const ConfirmLogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBackgroundColor,
      body: Center( // Center the content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Add horizontal padding
          child: Column(
            mainAxisSize: MainAxisSize.min, // Column takes minimum vertical space
            children: [
              // --- Icon Circle ---
              Container(
                padding: const EdgeInsets.all(25), // Adjust padding inside circle
                decoration: const BoxDecoration(
                  color: _iconCircleColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.exit_to_app, // Standard logout icon
                  color: _primaryTextColor,
                  size: 50, // Adjust icon size
                ),
              ),
              const SizedBox(height: 40), // Space below icon

              // --- Text Section ---
              const Text(
                "Oh no! You're Leaving...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryTextColor,
                  fontSize: 22, // Adjust font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _secondaryTextColor,
                  fontSize: 16, // Adjust font size
                ),
              ),
              const SizedBox(height: 50), // Space above buttons

              // --- Buttons Section ---
              // Using SizedBox to constrain width, making buttons appear smaller horizontally
              SizedBox(
                width: double.infinity, // Button takes full constrained width
                child: TextButton(
                  onPressed: () {
                    
                    debugPrint("Logout confirmed");
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: _primaryTextColor, // Text color
                    backgroundColor: Colors.transparent, // Transparent background
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Smaller vertical padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                      side: const BorderSide(color: _secondaryTextColor, width: 1), // Subtle border
                    ),
                  ),
                  child: const Text("Yes, Log Me Out", style: TextStyle(fontSize: 15)), // Adjust font size
                ),
              ),
              const SizedBox(height: 15), // Space between buttons

              SizedBox(
                width: double.infinity, // Button takes full constrained width
                child: ElevatedButton(
                   onPressed: () {
                    debugPrint("Logout cancelled");
                     if (Navigator.canPop(context)) {
                       Navigator.pop(context);
                     }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: _buttonTextColorDark, // Text color (dark)
                    backgroundColor: _primaryTextColor, // Background color (white)
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20), // Smaller vertical padding
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                   child: const Text("Nah, Still here", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)), // Adjust font size
                ),
              ),
               const SizedBox(height: 20), // Optional space at bottom
            ],
          ),
        ),
      ),
    );
  }
}