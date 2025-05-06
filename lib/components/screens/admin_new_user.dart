import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/admin_loan.dart';
import 'package:RHOLIC/components/screens/admin_messages.dart';


class NewUserScreen extends StatelessWidget {
  final List<Map<String, String>> newUsers = [
    {'name': 'Kamel', 'time': '3:30pm'},
    {'name': 'wafaa', 'time': '5:00pm'},
    {'name': 'chaimaa', 'time': '5:00pm'},
  ];

  NewUserScreen({super.key});

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
                  Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 20),),
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
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Use real image
                    ),
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
              SizedBox(height: 20), // Reduced from 33 to 20

              Text("Notifications", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white70)),

              SizedBox(height: 20), // Reduced from 30 to 20
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New User", style: TextStyle(color: Color.fromARGB(255, 165, 133, 20), fontWeight: FontWeight.bold, fontSize: 20)),

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

                  // Messages Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MessagesScreen(),
                ),
              );
                    },
                    child: Text("Messages", style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ),
                ],
              ),

              SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 50), // Removed left and right padding
                  itemCount: newUsers.length,
                  itemBuilder: (context, index) {
                    final user = newUsers[index];
                    final colors = [
                      const Color.fromARGB(255, 255, 183, 177),
                      const Color.fromARGB(255, 244, 183, 255),
                      const Color.fromARGB(255, 255, 225, 180),
                      const Color.fromARGB(255, 180, 255, 182),
                      const Color.fromARGB(255, 178, 255, 247),
                      const Color.fromARGB(255, 144, 201, 248),
                    ]; // Predefined colors
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colors[index % colors.length], // Assign color based on index
                        child: Text(
                          user['name']![0].toUpperCase(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        '${user['name']} ${index == 0 ? 'subscribed' : 'just subscribed'}',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(user['time']!, style: TextStyle(color: Colors.white70, fontSize: 12)),
                          SizedBox(height: 6),
                          Icon(Icons.circle, color: Colors.blue, size: 10),
                        ],
                      
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
