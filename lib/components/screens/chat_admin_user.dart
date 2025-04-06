import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add this in pubspec.yaml as a dependency

class AdminChatScreen extends StatelessWidget {
  const AdminChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(121, 32, 46, 172),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(121, 32, 46, 172),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 165, 133, 36),
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Admin chat",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color.fromARGB(255, 165, 133, 36),
              size: 30,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: BookDiscussion(),
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
  final ScrollController scrollController = ScrollController();

  final List<Map<String, dynamic>> messages = [
    {
      "user": "Admin",
      "message": "Hello, this is City Library Support. How can I help?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 10)),
    },
    {
      "user": "Chaima",
      "message": "your system says I didn’t return ‘1984’, but I did! Why am I being fined?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
    },
    {
      "user": "Admin",
      "message": "I’ve placed a hold on the fine and will check our after-hours bin. Expect an update within 24 hours",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 6)),
    },
    {
      "user": "Chaima",
      "message": "Thanks! I’ll wait for your email",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add({
          "user": "You",
          "message": text,
          "timestamp": DateTime.now(),
        });
        messageController.clear();
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index];
              return DiscussionMessage(
                user: msg["user"],
                message: msg["message"],
                timestamp: msg["timestamp"],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  minLines: 1,
                  maxLines: 5,
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
                mini: true,
                backgroundColor: const Color(0xFF578FCA),
                onPressed: sendMessage,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DiscussionMessage extends StatelessWidget {
  final String user;
  final String message;
  final DateTime timestamp;

  const DiscussionMessage({
    required this.user,
    required this.message,
    required this.timestamp,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUser = user == "You";
    final String timeString = DateFormat('h:mm a').format(timestamp);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.white10,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isUser ? 12 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Text(
                user,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              timeString,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
