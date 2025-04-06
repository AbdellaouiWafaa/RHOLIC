import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/notifications.dart';
import 'package:pfe_app/components/screens/profile.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0A0F3A),
        fontFamily: 'Poppins',
      ),
      home: const WishlistScreen(),
    );
  }
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0F3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color.fromARGB(255, 165, 133, 36)),
            onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsScreen(),
                      ),
                    );
                  },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          BookItem(
            author: 'The Forth Wing',
            bookName: 'Rebecca Yarrons',
            coverImage: 'assets/images/forth_wing.png',
            completionPercentage: 0,
         
          ),
          SizedBox(height: 22),
          BookItem(
            author: 'Her Body And Other Parties',
            bookName: 'Carmen Maria Machado',
            coverImage: 'assets/images/her_body.png',
            completionPercentage: 0,
            isScifi: true,
          ),
          SizedBox(height: 22),
          BookItem(
            author: 'War and Peace',
            bookName: 'Leo Tolstoy',
            coverImage: 'assets/images/war_peace.png',
            completionPercentage: 30,
          ),
        ],
      ),
    );
  }
}

class BookItem extends StatefulWidget {
  final String author;
  final String bookName;
  final String coverImage;
  final double completionPercentage;
  final Color? bottomCoverColor;
  final bool isScifi;

  const BookItem({
    super.key,
    required this.author,
    required this.bookName,
    required this.coverImage,
    required this.completionPercentage,
    this.bottomCoverColor,
    this.isScifi = false,
  });

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  bool isChecked = false;

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
          // Book Cover
          BookCover(
            coverImage: widget.coverImage,
            bottomCoverColor: widget.bottomCoverColor,
            isScifi: widget.isScifi,
          ),
          const SizedBox(width: 16),
          // Book Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.author,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.bookName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: widget.completionPercentage / 100,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.completionPercentage.toInt()}% completed',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
  onPressed: () {
    // Delete logic here
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 165, 133, 36),
    minimumSize: const Size(10, 36), // Smaller width & height
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text(
    'DELETE',
    style: TextStyle(
      color:Color.fromARGB(204, 255, 255, 255),
      fontSize: 15, // Smaller text
      fontWeight: FontWeight.w600,
    ),
  ),
)

                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 44, 44, 44),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check,
                          color: isChecked ? const Color.fromARGB(255, 54, 152, 58) : Colors.white,
                          size: 27,
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
  final Color? bottomCoverColor;
  final bool isScifi;

  const BookCover({
    super.key,
    required this.coverImage,
    this.bottomCoverColor,
    this.isScifi = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        image: DecorationImage(
          image: AssetImage(coverImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          if (bottomCoverColor != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 50,
              child: Container(
                decoration: BoxDecoration(
                  color: bottomCoverColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
            ),
          if (isScifi)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xFF2196F3)],
                    stops: [0.6, 1.0],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
