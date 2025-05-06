import 'package:flutter/material.dart';
import 'package:RHOLIC/components/screens/admin_messages.dart';
import 'package:RHOLIC/components/screens/admin_new_user.dart';

class AdminLoanScreen extends StatelessWidget {
  final List<Map<String, dynamic>> reservedBooks = [
    {
      'name': 'Kamso',
      'book': 'Dracula',
      'time': '3:30pm',
      'cover': 'assets/images/dracula.png'
    },
    {
      'name': 'chaimaa',
      'book': 'Fankestein',
      'time': '4:30pm',
      'cover': 'assets/images/frankenstein.png'
    },
  ];

   AdminLoanScreen({super.key});

 

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
                    onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NewUserScreen(),
                ),
              );
            },
                    child: Text("New User", style: TextStyle(color: Colors.white70, fontSize: 20)),
                  ),

                  
                  Text("Loan", style: TextStyle(color: Color.fromARGB(255, 165, 133, 20), fontWeight: FontWeight.bold, fontSize: 20)),

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
                  padding: EdgeInsets.only(bottom: 20),
                  itemCount: reservedBooks.length,
                  itemBuilder: (context, index) {
                    final book = reservedBooks[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            book['cover'],
                            width: 30,
                            height: double.infinity, // Set height to fill the container
                            fit: BoxFit.cover, // Ensure the image covers the available space
                          ),
                        ),
                        title: Text(
                          '${book['name']} reserved " ${book['book']} "',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: () {
                              // Add your confirmation logic here
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white10,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Text(
                              'Confirm',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(book['time'], style: TextStyle(color: Colors.white70, fontSize: 12)),
                            SizedBox(height: 6),
                            Icon(Icons.circle, color: Colors.blue, size: 10),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
