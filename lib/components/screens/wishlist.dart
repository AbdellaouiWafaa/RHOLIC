import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/profile.dart';

void main() {
  runApp(const WishListScreen());
}

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(121, 32, 46, 172),
        fontFamily: 'Poppins',
      ),
      home: const WishlistScreen(),
    );
  }
}

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, String>> wishlist = [
    {
      'author': 'Rebecca Yarrons',
      'bookName': 'The Forth Wing',
      'coverImage': 'assets/images/forth_wing.png',
    },
    {
      'author': 'Carmen Maria Machado',
      'bookName': 'Her Body And Other Parties',
      'coverImage': 'assets/images/her_body.png',
    },
    {
      'author': 'Leo Tolstoy',
      'bookName': 'War and Peace',
      'coverImage': 'assets/images/war_peace.png',
    },
  ];

  void removeBook(int index) {
    setState(() {
      wishlist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(121, 32, 46, 172),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
       
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final book = wishlist[index];
          return Column(
            children: [
              BookItem(
                author: book['author']!,
                bookName: book['bookName']!,
                coverImage: book['coverImage']!,
                onDelete: () => removeBook(index),
              ),
              const SizedBox(height: 22),
            ],
          );
        },
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String author;
  final String bookName;
  final String coverImage;
  final void Function()? onDelete;

  const BookItem({
    super.key,
    required this.author,
    required this.bookName,
    required this.coverImage,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          BookCover(coverImage: coverImage),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  bookName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const LinearProgressIndicator(
                  value: 0,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                const Text(
                  '0% completed',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onDelete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                          minimumSize: const Size(10, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'DELETE',
                          style: TextStyle(
                            color: Color.fromARGB(204, 255, 255, 255),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  final String coverImage;

  const BookCover({
    super.key,
    required this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(coverImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
