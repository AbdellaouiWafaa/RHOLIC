import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/code_enter.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';

class GenreSelectionScreen extends StatefulWidget {
  const GenreSelectionScreen({super.key});

  @override
  State<GenreSelectionScreen> createState() => _GenreSelectionScreenState();
}

class _GenreSelectionScreenState extends State<GenreSelectionScreen> {
  final List<String> genres = [
    "Science & Technology",
    "Adventure",
    "Art",
    "science",
    "Health & Wellness",
    "Biographies & Memoirs",
    "Fiction",
    "Self-Help & Personal Development",
    "Psychology",
    "Philosophy",
    "Horror",
    "Business & Economics",
    "Graphic Novels & Comics",
  ];

  final List<String> selectedGenres = [];

  void toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        if (selectedGenres.length < 5) {
          selectedGenres.add(genre);
        } else {
          // Optional: show a message/snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You can only select up to 5 genres.")),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFA58524)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: selectedGenres.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  }
                : null,
            child: Text(
              "NEXT",
              style: TextStyle(
                color: selectedGenres.isNotEmpty ? const Color(0xFFA58524) : Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: const Color.fromARGB(255, 10, 15, 58),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: const Text(
              "what do you like to read?",
              style: TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Text(
              "select 5 or less of your favotires genres",
              style: TextStyle(color: Color.fromARGB(232, 0, 0, 0), fontSize: 14),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: genres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);
                  return ChoiceChip(
                    label: Text(
                      genre,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    backgroundColor: Colors.grey[200],
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF1A237E)
                            : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    shadowColor: Colors.black45,
                    elevation: 4,
                    onSelected: (_) => toggleGenre(genre),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    child: SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OtpScreen(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text("Already a member ?", style: TextStyle(fontSize: 20)),
    ),
  ),
),

          
        ],
      ),
    );
  }
}
