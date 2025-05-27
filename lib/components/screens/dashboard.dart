import 'package:RHOLIC/Admin_interfaces/book_service.dart';
import 'package:RHOLIC/components/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/books_shelf.dart';
import 'package:RHOLIC/components/screens/chatbox.dart';
import 'package:RHOLIC/components/screens/first_page.dart';
import 'package:RHOLIC/components/screens/profile.dart';
import 'package:RHOLIC/components/screens/user_notif.dart';
import 'package:RHOLIC/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String backendBaseUrl = 'https://backendapp-production-3be4.up.railway.app';

class DashboardScreen extends StatefulWidget {
  final String? username;
  const DashboardScreen({super.key, this.username});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;
  final BookService _bookService = BookService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isSearching = false;
  bool hasSearched = false;
  Map<int, bool> addedBooks = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.6,
      initialPage: (_bookService.userBooks.length / 2).floor(),
    );
    _bookService.addListener(_onBooksChanged);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _bookService.removeListener(_onBooksChanged);
    super.dispose();
  }

  void _onBooksChanged() {
    if (mounted) {
      setState(() {
        // Reset page controller when books change
        _pageController = PageController(
          viewportFraction: 0.6,
          initialPage: (_bookService.userBooks.length / 2).floor(),
        );
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      _showNoBooksFoundAlert();
    }
  }

  void _showNoBooksFoundAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Books Found'),
          content: const Text('Try searching with different keywords'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = _bookService.userBooks;

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
          'assets/images/both.png',
          height: 90,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color.fromARGB(255, 165, 133, 36),
            ),
            onPressed: () {
              Navigator.push(context,
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
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search books...",
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
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
                  const SizedBox(
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
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: searchResults.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final book = searchResults[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: book['image'] != null && book['image'].toString().isNotEmpty
                                          ? Image.network(
                                              book['image'].toString(),
                                              width: 60,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.book,
                                                    color: Colors.grey,
                                                    size: 30,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 60,
                                              height: 80,
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.book,
                                                color: Colors.grey,
                                                size: 30,
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            book['title']?.toString() ?? 'Unknown Title',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            book['author']?.toString() ?? 'Unknown Author',
                                            style: const TextStyle(
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
                                const Icon(
                                  Icons.search_off,
                                  color: Colors.white54,
                                  size: 50,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No books found',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Try searching with different keywords',
                                  style:
                                   TextStyle(
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
              decoration: const BoxDecoration(
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
                          child: _buildBookCard(books[index], index),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
              ),
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
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
                          color: _selectedIndex == 0
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
                          color: UserData.isOtpEntered ? Colors.white : Colors.white38,
                          size: 30,
                        ),
                        onPressed: UserData.isOtpEntered
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BookListScreen(),
                                  ),
                                );
                                _onItemTapped(1);
                              }
                            : null,
                      ),
                      IconButton(
                          icon: Icon(
                          Icons.chat_bubble_outline,
                          color: UserData.isOtpEntered ? Colors.white : Colors.white38,
                          size: 30,
                        ),
                        onPressed: UserData.isOtpEntered
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChatBoxScreen(),
                                  ),
                                );
                                _onItemTapped(2);
                              }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.person_outline_rounded,
                          color: UserData.isOtpEntered ? Colors.white : Colors.white38,
                          size: 30,
                        ),
                        onPressed: UserData.isOtpEntered
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                                _onItemTapped(3);
                              }
                            : null,
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

  Widget _buildBookCard(Map<String, dynamic> book, int index) {
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
            book['title'],
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            book['author'],
            style: const TextStyle(
              color: Color.fromARGB(153, 0, 0, 0),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                book['image'],
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 100),
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
                child: const Text(
                  "View Details",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isAdded ? Icons.check : Icons.add,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: 25,
                ),
                onPressed: () {
                  setState(() {
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