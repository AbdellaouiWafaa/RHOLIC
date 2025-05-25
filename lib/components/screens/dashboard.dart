import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/books_shelf.dart';
import 'package:RHOLIC/components/screens/chatbox.dart';
import 'package:RHOLIC/components/screens/first_page.dart';
import 'package:RHOLIC/components/screens/login.dart';
import 'package:RHOLIC/components/screens/profile.dart';
import 'package:RHOLIC/components/screens/user_notif.dart';
import 'package:RHOLIC/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String backendBaseUrl =
    'https://backendapp-production-3be4.up.railway.app';

class DashboardScreen extends StatefulWidget {
  final String? username;
  const DashboardScreen({super.key, this.username});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6,
      initialPage: (books.length / 2).floor(),
    );
  }

  List<Map<String, String>> books = [
    {
      'title': 'Dracula',
      'author': 'Bram Stoker',
      'image': 'assets/images/dracula.png',
    },
    {
      'title': 'Frankenstein',
      'author': 'Mary Shelley',
      'image': 'assets/images/frankenstein.png',
    },
    {
      'title': 'Alice Wonderlands',
      'author': 'Lewis Carroll',
      'image': 'assets/images/alice.png',
    },
    {
      'title': 'War and Peace',
      'author': 'Leo Tolstoy',
      'image': 'assets/images/war_peace.png',
    },
    {
      'author': 'Rebecca Yarrons',
      'title': 'The Forth Wing',
      'image': 'assets/images/forth_wing.png',
    },
  ];

  Map<int, bool> addedBooks = {};

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;
  bool hasSearched = false;

  Future<void> searchBooks(String query) async {
    setState(() {
      isSearching = true;
      hasSearched = true;
    });
    final url = Uri.parse('$backendBaseUrl/api/search?query=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        searchResults = List<Map<String, dynamic>>.from(data);
        isSearching = false;
      });
    } else {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
      // Show alert dialog when no books are found
      _showNoBooksFoundAlert();
    }
  }

  void _showNoBooksFoundAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No Books Found'),
          content: Text('Try searching with different keywords.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 165, 133, 36),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FirstpageScreen()),
            );
          },
        ),
        title: Image.asset(
          'assets/images/both.png', // change this path if needed
          height: 90, // adjust based on your logo size
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color.fromARGB(255, 165, 133, 36),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserNotifScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(children: [
                const SizedBox(height: 20),
                Text(
                  "Welcome ${UserData.username ?? widget.username ?? 'among us'}",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search books...",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        searchBooks(value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 5),
                if (isSearching)
                  SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 165, 133, 36),
                      ),
                    ),
                  )
                else if (hasSearched)
                  Container(
                    height: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: searchResults.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final book = searchResults[index];
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    // Book Cover
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: book['cover'] != null && book['cover'].toString().isNotEmpty
                                          ? Image.network(
                                              book['cover'].toString(),
                                              width: 60,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.book,
                                                    color: Colors.grey[600],
                                                    size: 30,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 60,
                                              height: 80,
                                              color: Colors.grey[300],
                                              child: Icon(
                                                Icons.book,
                                                color: Colors.grey[600],
                                                size: 30,
                                              ),
                                            ),
                                    ),
                                    SizedBox(width: 12),
                                    // Book Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book['title']?.toString() ?? 'Unknown Title',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            book['author']?.toString() ?? 'Unknown Author',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  color: Colors.white54,
                                  size: 50,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No books found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Try searching with different keywords',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
              ]),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 20,
            right: 20,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 120),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1;
                        if (_pageController.position.haveDimensions) {
                          value = (_pageController.page! - index).abs();
                          value = (1 - (value * 0.8)).clamp(0.7, 1.0);
                        }
                        return Transform.scale(
                          scale: value,
                          child: bookCard(context, books[index], index),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
              ),
              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 8.0,
                color: const Color.fromARGB(104, 29, 27, 86),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(right: 0.0, left: 5.0),
                        icon: Image.asset(
                          'assets/images/white_logo.png',
                          color:
                              _selectedIndex == 0
                                  ? const Color.fromARGB(255, 165, 133, 36)
                                  : Colors.white,
                          width: 85,
                          height: 85,
                        ),
                        onPressed: () => _onItemTapped(0),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 20.0, left: 0.0),
                        icon: Icon(
                          Icons.menu_book_sharp,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BookListScreen(),
                            ),
                          );
                          _onItemTapped(1);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
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
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
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
    );
  }

  Widget bookCard(BuildContext context, Map<String, String> book, int index) {
    // Default to false if not in map
    bool isAdded = addedBooks[index] ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "BASED ON YOUR PREFERENCES",
            style: TextStyle(
              color: const Color.fromARGB(179, 0, 0, 0),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book['title']!,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            book['author']!,
            style: TextStyle(
              color: const Color.fromARGB(153, 0, 0, 0),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                book['image']!,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
                child: Text(
                  "View Details",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Spacer(), // Add spacer to push the add icon to the right
              IconButton(
                icon: Icon(
                  isAdded ? Icons.check : Icons.add,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
                    // Toggle the added state for this book
                    addedBooks[index] = !isAdded;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final String bookTitle;

  const BookDetailsPage({super.key, required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bookTitle)),
      body: Center(
        child: Text(
          'Book details here: $bookTitle',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}