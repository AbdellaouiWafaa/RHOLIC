import 'package:flutter/material.dart';

class UserNotifScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Book Release!',
      'message': 'Check out the new book just added to the library.',
      'timestamp': DateTime.now().subtract(Duration(minutes: 15)),
    },
    {
      'title': 'Loan Reminder',
      'message': 'Your loan period is about to end in 3 days.',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
    },
  ];

  final Color mainColor = const Color.fromARGB(121, 32, 46, 172);

   UserNotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Card(
            color: Colors.white54, // Lighter background
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                
                title: Text(
                  notif['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    Text(
                      notif['message'],
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 6),
                    Text(
                      _formatTimestamp(notif['timestamp']),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hrs ago';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}