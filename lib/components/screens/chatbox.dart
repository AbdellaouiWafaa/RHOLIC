import 'package:RHOLIC/components/screens/first_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/books_shelf.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';
import 'package:RHOLIC/components/screens/profile.dart';
import 'package:RHOLIC/components/screens/user_notif.dart';

class ChatBoxScreen extends StatelessWidget {
  const ChatBoxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 165, 133, 36),
            size: 30,
          ),
          onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirstpageScreen(),
                ),
              );
            },
        ),
        actions: [//
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color.fromARGB(255, 165, 133, 36),
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  UserNotifScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "Currently Reading"),
              const CurrentlyReading(),
              const SizedBox(height: 20),
              const SectionTitle(title: "Book Discussions"),
              const BookDiscussion(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}

class CurrentlyReading extends StatelessWidget {
  const CurrentlyReading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 150,
            width: 120,
            child: Image.asset("assets/images/alice.png", height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alice Wonderlands",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Lewis Carroll",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                const LinearProgressIndicator(value: 0.75, color: Colors.blue),
                const SizedBox(height: 10),
                Text(
                  "75% completed",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 165, 133, 36),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Continue Reading"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookDiscussion extends StatefulWidget {
  const BookDiscussion({super.key});

  @override
  State<BookDiscussion> createState() => _BookDiscussionState();
}

class _BookDiscussionState extends State<BookDiscussion> {
  final TextEditingController messageController = TextEditingController();
  // List to store all discussion messages
  final List<Map<String, String>> messages = [
    {"user": "Chaimaa", "message": "The plot twist in chapter 7 was incredible!"},
    {"user": "Wafaa", "message": "The characters development is amazing"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Display all messages
          ...messages.map((msg) => DiscussionMessage(
                user: msg["user"]!,
                message: msg["message"]!,
              )),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  backgroundColor: const Color(0xFF578FCA),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      // Add the new message to the list
                      setState(() {
                        messages.add({
                          "user": "You", // You can change this to the current user's name
                          "message": messageController.text,
                        });
                      });
                      // Clear the text field
                      messageController.clear();
                    }
                  },
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiscussionMessage extends StatelessWidget {
  final String user;
  final String message;

  const DiscussionMessage({super.key, required this.user, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF303030),
            child: Icon(Icons.account_circle, size: 32, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 165, 133, 36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(message, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigation();
}

class _BottomNavigation extends State<BottomNavigation> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
                  icon: Icon(Icons.chat_bubble_outline,
                      color: _selectedIndex == 2 ? const Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                  onPressed: () => _onItemTapped(2),
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
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}