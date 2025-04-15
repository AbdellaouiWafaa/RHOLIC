import 'package:flutter/material.dart';

class MessageDetailScreen extends StatefulWidget {
  final Map<String, dynamic> message;

  const MessageDetailScreen({super.key, required this.message});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hey I was wondering if you couldanswer some questions??',
      'isMe': false,
     
    },
    {
      'text': 'Yeah! sure.',
      'isMe': true,
     
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isMe': true,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
    });
    
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 26, 39),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(255, 255, 255, 0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Back button and time
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 20)),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      Spacer(),
                      
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Profile
                  CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 209, 176, 76),
                    radius: 35,
                    child: Text(
                      widget.message['initial'] ?? 'W',
                      style: TextStyle(color: Color.fromARGB(255, 70, 58, 26), fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Name
                  Text(
                    widget.message['name'] ?? 'Wafaa',
                    style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 5),
                  
                  // Divider
                  Container(
                    width: 120,
                    height: 0.5,
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                ],
              ),
            ),
            
            // Messages
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Align(
                    alignment: msg['isMe'] ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: msg['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 10, 
                            left: msg['isMe'] ? 60 : 0,
                            right: msg['isMe'] ? 0 : 60,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: msg['isMe'] 
                              ? Color.fromARGB(255, 74, 99, 115) 
                              : Color.fromRGBO(255, 255, 255, 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        Text(
                          msg['time'] ?? '',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Message input
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 74, 99, 115),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      icon: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// Function to receive new messages from your backend
void receiveNewMessage(BuildContext context, Map<String, dynamic> newMessage) {
  // Show notification
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('New message from ${newMessage['name']}'),
      action: SnackBarAction(
        label: 'View',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageDetailScreen(message: newMessage),
            ),
          );
        },
      ),
    ),
  );
}