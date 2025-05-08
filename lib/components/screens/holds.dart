import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/books_shelf.dart';
import 'package:RHOLIC/components/screens/chatbox.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';
import 'package:RHOLIC/components/screens/notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/profile.dart';

class HoldsListScreen extends StatefulWidget {
  const HoldsListScreen({super.key});

  @override
  _HoldsListScreenState createState() => _HoldsListScreenState();
}

class _HoldsListScreenState extends State<HoldsListScreen> {
  int _selectedIndex = 1;
  List<Map<String, String>> bookmarkedBooks = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addBookToHolds(String title, String author, String imagePath) {
    setState(() {
      bookmarkedBooks.add({
        'title': title,
        'author': author,
        'image': imagePath,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
    appBar: AppBar( 
  backgroundColor: const Color.fromARGB(255, 10, 15, 58),
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    },
  ),
  title: const Text(
    'RHOLIC SHELF',
    style: TextStyle(
      letterSpacing: 2,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  centerTitle: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.notifications_outlined, color: Color.fromARGB(255, 165, 133, 36)),
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


      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            margin: EdgeInsets.only(top: screenHeight * 0.01),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                const TextSpan(
                                  text: 'The ',
                                  style: TextStyle(color: Color.fromARGB(255, 10, 15, 58), fontSize: 16),
                                ),
                                TextSpan(
                                  text: ' BOOKS ',
                                  style: GoogleFonts.ebGaramond(
                                    color: const Color.fromARGB(255, 165, 133, 36),
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(
                                  text: ' You currently have in your stack',
                                  style: TextStyle(color: Color.fromARGB(255, 10, 15, 58), fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildChip('Loans', const Color.fromARGB(255, 10, 15, 58),  Colors.white,
                             onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookListScreen(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: screenWidth * 0.08),
                            SizedBox(width: screenWidth * 0.08),
                            _buildChip(
                              'Holds',
                              Colors.white, const Color.fromARGB(255, 10, 15, 58),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: [
                            _buildBookItem(1, 'Dracula', 'Bram Stoker', 'assets/images/dracula.png', 0.02, 2, screenWidth),
                            _buildBookItem(2, 'Frankenstein', 'Mary Shelley', 'assets/images/frankenstein.png', 0.02, 2, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(120.0),
                topRight: Radius.circular(120.0),
              ),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                notchMargin: 5.0,
                color: const Color.fromARGB(200, 10, 15, 58),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(right: 0.0, left: 5.0),
                        icon: Image.asset(
                          'assets/images/white_logo.png',
                          color: _selectedIndex == 0 ? const Color.fromARGB(255, 165, 133, 36) : Colors.white,
                          width: 85,
                          height: 85,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                          _onItemTapped(0);
                        },
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 20.0, left: 0.0),
                        icon: Icon(Icons.menu_book_sharp,
                            color: _selectedIndex == 1 ? const Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                        onPressed: () => _onItemTapped(1),
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline,
                            color: _selectedIndex == 2 ? const Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatBoxScreen(),
                            ),
                          );
                          _onItemTapped(2);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.person_outline_rounded,
                            color: _selectedIndex == 3 ? const Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                          _onItemTapped(3);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HoldsScreen(bookmarkedBooks: bookmarkedBooks),
            ),
          );
        },
        child: const Icon(Icons.bookmark),
      ),
    );
  }

  // Modified to remove the count parameter
  Widget _buildChip(String label, Color textColor, Color backgroundColor, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Chip(
        label: Text(label, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      ),
    );
  }

  Widget _buildBookItem(int rank, String title, String author, String imagePath, double progress, int daysLeft, double screenWidth) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.33,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 12,
                    child: Text(
                      "$rank",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 10, 15, 58))),
                  const SizedBox(height: 3),
                  Text(author, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                  const SizedBox(height: 10),
                  Text(
                    "${(progress * 100).toStringAsFixed(0)}%",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    color: const Color.fromARGB(255, 10, 15, 58),
                    backgroundColor: Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Manage Loan",
                          style: TextStyle(color: Color.fromARGB(255, 10, 15, 58)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Color.fromARGB(255, 10, 15, 58)),
                        onPressed: () {
                          _addBookToHolds(title, author, imagePath);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoldsScreen extends StatelessWidget {
  final List<Map<String, String>> bookmarkedBooks;

  const HoldsScreen({super.key, required this.bookmarkedBooks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Books'),
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      ),
      body: ListView.builder(
        itemCount: bookmarkedBooks.length,
        itemBuilder: (context, index) {
          final book = bookmarkedBooks[index];
          return ListTile(
            leading: Image.asset(book['image']!, width: 50, height: 50),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}