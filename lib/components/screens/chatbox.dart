import 'package:RHOLIC/components/screens/book_reader.dart';
import 'package:RHOLIC/components/screens/first_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:RHOLIC/components/screens/books_shelf.dart';
import 'package:RHOLIC/components/screens/dashboard.dart';
import 'package:RHOLIC/components/screens/profile.dart';
import 'package:RHOLIC/components/screens/user_notif.dart';
import 'package:RHOLIC/user_data.dart';
const String backendBaseUrl =
    'https://backendapp-production-3be4.up.railway.app';

// Persistent chat data storage
class ChatData {
  static List<Map<String, dynamic>> messages = [
    <String, dynamic>{
      "id": "1",
      "user": "Chaimaa", 
      "message": "The plot twist in chapter 7 was incredible!",
      "reactions": <String, int>{"❤️": 2, "👍": 1},
      "replies": <Map<String, String>>[
        <String, String>{"user": "Wafaa", "message": "I know! I didn't see it coming!"}
      ]
    },
    <String, dynamic>{
      "id": "2",
      "user": "Wafaa", 
      "message": "The characters development is amazing",
      "reactions": <String, int>{"👍": 3},
      "replies": <Map<String, String>>[]
    },
  ];

  static void addMessage(String message) {
    messages.add(<String, dynamic>{
      "id": (messages.length + 1).toString(),
      "user": UserData.username ?? UserData.name ?? "You",
      "message": message,
      "reactions": <String, int>{},
      "replies": <Map<String, String>>[],
    });
  }

  static void addReply(String messageId, String reply) {
    final messageIndex = messages.indexWhere((msg) => msg["id"] == messageId);
    if (messageIndex != -1) {
      final List<Map<String, String>> replies = List<Map<String, String>>.from(messages[messageIndex]["replies"] as List);
      replies.add(<String, String>{
        "user": UserData.username ?? UserData.name ?? "You",
        "message": reply,
      });
      messages[messageIndex]["replies"] = replies;
    }
  }

  static void addReaction(String messageId, String reaction) {
    final messageIndex = messages.indexWhere((msg) => msg["id"] == messageId);
    if (messageIndex != -1) {
      final Map<String, int> reactions = Map<String, int>.from(messages[messageIndex]["reactions"] as Map);
      if (reactions.containsKey(reaction)) {
        reactions[reaction] = reactions[reaction]! + 1;
      } else {
        reactions[reaction] = 1;
      }
      messages[messageIndex]["reactions"] = reactions;
    }
  }
}

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
        actions: [
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
                
                const SizedBox(height: 10),
                
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () { Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookReaderScreen(
                                    bookTitle: 'Alice in Wonderland',
                                    author: 'Lewis Carroll',
                                    expiryDate: DateTime.now(),
                                  ),
                                ),
                              );},
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
  
  // To track which message is being replied to
  String? replyingToId;
  String? replyingToUser;

  void setReplyTo(String messageId, String user) {
    setState(() {
      replyingToId = messageId;
      replyingToUser = user;
    });
  }

  void cancelReply() {
    setState(() {
      replyingToId = null;
      replyingToUser = null;
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        if (replyingToId != null) {
          // Add reply to the specified message
          ChatData.addReply(replyingToId!, messageController.text);
          // Clear reply state
          replyingToId = null;
          replyingToUser = null;
        } else {
          // Add as a new message
          ChatData.addMessage(messageController.text);
        }
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ...ChatData.messages.map((msg) => DiscussionMessageCard(
                messageId: msg["id"] as String,
                user: msg["user"] as String,
                message: msg["message"] as String,
                reactions: Map<String, int>.from(msg["reactions"] as Map),
                replies: List<Map<String, String>>.from((msg["replies"] as List).map((reply) => Map<String, String>.from(reply as Map))),
                onReply: () => setReplyTo(msg["id"] as String, msg["user"] as String),
                onReaction: (reaction) {
                  setState(() {
                    ChatData.addReaction(msg["id"] as String, reaction);
                  });
                },
              )),
          if (replyingToUser != null)
            Container(
              color: Colors.black26,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Replying to $replyingToUser",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: cancelReply,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: replyingToUser != null 
                          ? "Reply to $replyingToUser..." 
                          : "Type a message...",
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
                  onPressed: sendMessage,
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

class DiscussionMessageCard extends StatelessWidget {
  final String messageId;
  final String user;
  final String message;
  final Map<String, int> reactions;
  final List<Map<String, String>> replies;
  final VoidCallback onReply;
  final Function(String) onReaction;

  const DiscussionMessageCard({
    super.key, 
    required this.messageId,
    required this.user, 
    required this.message, 
    required this.reactions,
    required this.replies,
    required this.onReply,
    required this.onReaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main message
          Row(
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
          
          // Reactions display
          if (reactions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 8, left: 50),
              child: Wrap(
                spacing: 8,
                children: reactions.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${entry.key} ${entry.value}",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Replies
          if (replies.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10, left: 50),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: replies.map<Widget>((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reply["user"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 165, 133, 36),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          reply["message"]!,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          
          // Action buttons for reply and reactions
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 50),
            child: Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.reply, size: 16, color: Colors.white70),
                  label: const Text('Reply', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  onPressed: onReply,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.add_reaction, size: 16, color: Colors.white70),
                  tooltip: 'Add reaction',
                  color: const Color.fromARGB(255, 30, 35, 78),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: '👍', child: Text('👍 Like')),
                    const PopupMenuItem(value: '❤️', child: Text('❤️ Love')),
                    const PopupMenuItem(value: '😂', child: Text('😂 Laugh')),
                    const PopupMenuItem(value: '😮', child: Text('😮 Wow')),
                    const PopupMenuItem(value: '😢', child: Text('😢 Sad')),
                  ],
                  onSelected: onReaction,
                ),
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