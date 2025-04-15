import 'package:flutter/material.dart';

// --- Define constant colors with opacity ---
const Color _cardBackgroundColor =  Color.fromARGB(121, 32, 46, 172); // White with 10% opacity
const Color _secondaryTextColor = Color.fromRGBO(255, 255, 255, 0.7); // White with 70% opacity
const Color _progressBackgroundColor = Color.fromRGBO(255, 255, 255, 0.3); // White with 30% opacity
const Color _percentageTextColor = Color.fromRGBO(255, 255, 255, 0.8); // White with 80% opacity
const Color _appBackgroundColor =   Color.fromARGB(121, 32, 46, 172); // Dark blue background
// --- End of constant color definitions ---


// Placeholder data using Maps for simplicity
// Ensure image paths match your assets folder structure
final List<Map<String, dynamic>> recentlyRead = [
  {
    'title': 'The Art of Silence',
    'author': 'James Wilson',
    'progress': 0.67,
    'image': 'assets/images/war_peace.png' // Replace with your actual asset path
  },
  {
    'title': 'Mystic Realms',
    'author': 'Luna Park',
    'progress': 0.83,
    'image': 'assets/images/her_body.png' // Replace with your actual asset path
  },
  // Add more recently read books if needed
];

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _appBackgroundColor,
      // --- Added AppBar ---
      appBar: AppBar(
        backgroundColor: _appBackgroundColor, // Match background
        elevation: 0, // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () {
            // Action for back button
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        // Optional: Add a title if you want
        title: const Text(
           'History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         ),
         centerTitle: true,
      ),
      // --- Modified Body Structure ---
      body: SafeArea( // SafeArea might be redundant if AppBar is present, but harmless
        child: Padding( // Add padding around the whole body content
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Expanded Scrollable Section ---
              Expanded(
                child: SingleChildScrollView(
                  // Removed vertical padding here, handled by Column padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8), // Add some space below AppBar
                      _buildSectionTitle('Recently Read'),
                      const SizedBox(height: 9),
                      _buildRecentlyReadList(),
                    ],
                  ),
                ),
              ),
              // --- Fixed Bottom Section (Reading Stats) ---
              const SizedBox(height: 16), // Space above stats section
              _buildSectionTitle('Your Reading Stats'),
              const SizedBox(height: 3),
              _buildReadingStats(),
              const SizedBox(height: 20), // Space below stats at the bottom
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Builder Methods (Unchanged) ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentlyReadList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentlyRead.length,
      itemBuilder: (context, index) {
        final book = recentlyRead[index];
        return Card(
          color: _cardBackgroundColor,
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    book['image']!,
                    width: 70,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 70,
                        color: Colors.grey[800],
                        child: const Center(child: Icon(Icons.book, color: Colors.white54, size: 30,))
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title']!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book['author']!,
                        style: const TextStyle(color: _secondaryTextColor, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                         children: [
                           Expanded(
                             child: LinearProgressIndicator(
                              value: book['progress'],
                              backgroundColor: _progressBackgroundColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(3),
                             ),
                           ),
                           const SizedBox(width: 8),
                           Text(
                            '${(book['progress'] * 100).toInt()}%',
                             style: const TextStyle(color: _percentageTextColor, fontSize: 12),
                           )
                         ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   Widget _buildReadingStats() {
     const String booksRead = "12";
     const String readingTime = "48h";
     const String avgRating = "4.8";

     return Card(
       color: _cardBackgroundColor,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             _buildStatItem(booksRead, "Books Read"),
             _buildStatItem(readingTime, "Reading Time"),
             _buildStatItem(avgRating, "Avg Rating"),
           ],
         ),
       ),
     );
   }

   Widget _buildStatItem(String value, String label) {
     return Column(
       mainAxisSize: MainAxisSize.min,
       children: [
         Text(
           value,
           style: const TextStyle(
             color: Colors.blueAccent,
             fontSize: 20,
             fontWeight: FontWeight.bold,
           ),
         ),
         const SizedBox(height: 4),
         Text(
           label,
           style: const TextStyle(color: _secondaryTextColor, fontSize: 12),
         ),
       ],
     );
   }
}