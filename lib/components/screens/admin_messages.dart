import 'package:flutter/material.dart';
import 'package:pfe_app/components/screens/admin_loan.dart';
import 'package:pfe_app/components/screens/admin_new_user.dart';
import 'package:pfe_app/components/screens/chat_user.dart';

class MessagesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> messages = [
    {
      'name': 'wafaa',
      'content': 'just sent a new message',
      'time': '4:30pm',
      'initial': 'W',
      'color': Color.fromARGB(255, 209, 176, 76), // Gold color for the avatar
    },
    // You can add more messages here
  ];

  MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 26, 39),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Icon
              Row(
                children: [
                  Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 20)),
                ],
              ),
              SizedBox(height: 15),

              // Search bar
              TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  suffixIcon: Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Welcome
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/profile_image.jpg'),
                  ),
                  SizedBox(width: 17),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Welcome Back,", style: TextStyle(fontSize: 22, color: Colors.white)),
                      Text("Jane", style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17, color: Colors.white70)),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),

              Text("Notifications", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white70)),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // New User Button
                  TextButton(
                    onPressed: (){
                      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NewUserScreen(),
                ),
              );
                    },
                    child: Text("New User", style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ),

                  // Loan Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  AdminLoanScreen(),
                ),
              );
                    },
                    child: Text("Loan", style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ),

                  // Messages Button - Active
                  Text("Messages", style: TextStyle(color: Color.fromARGB(255, 165, 133, 20), fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),

              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 50),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to message detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageDetailScreen(message: message),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.05),
                         borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: message['color'],
                            radius: 25,
                            child: Text(
                              message['initial'],
                              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            '${message['name']} ${message['content']}',
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(message['time'], style: TextStyle(color: Colors.white70, fontSize: 12)),
                              SizedBox(height: 6),
                              Icon(Icons.circle, color: Colors.blue, size: 10),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}