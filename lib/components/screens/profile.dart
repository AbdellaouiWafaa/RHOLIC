import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pfe_app/components/screens/books_shelf.dart'; // Contains BookListScreen
import 'package:pfe_app/components/screens/chat_admin_user.dart';
import 'package:pfe_app/components/screens/chatbox.dart';
import 'package:pfe_app/components/screens/dashboard.dart';
import 'package:pfe_app/components/screens/exit.dart';
import 'package:pfe_app/components/screens/history.dart';   
import 'package:pfe_app/components/screens/library_card.dart';
import 'package:pfe_app/components/screens/personnel_infos.dart';
import 'package:pfe_app/components/screens/user_notif.dart';
import 'package:pfe_app/components/screens/wishlist.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 10, 15, 58), // Match primaryColor?
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.dark(
           primary: const Color.fromARGB(255, 10, 15, 58), // Match primaryColor
           secondary: Color.fromARGB(255, 165, 133, 36), // Match accentColor
        )
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3;


  final Color primaryColor = const Color.fromARGB(255, 10, 15, 58);
  final Color accentColor = Color.fromARGB(255, 165, 133, 36);
  final Color textColor = Colors.white;
  final Color bottomNavBarColor = const Color.fromARGB(121, 32, 46, 172);
  final Color subduedTextColor = Color(0xB3FFFFFF);
  final Color subduedIconColor= Color(0xB3FFFFFF);

  // --- Navigation Logic for Bottom Bar ---
  void _onItemTapped(int index) {
    // ... (Bottom nav logic remains the same) ...
     if (_selectedIndex != index) {
      setState(() { _selectedIndex = index; });
      switch (index) {
         case 0: Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_,__,___) => const DashboardScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero)); break;
         case 1: Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (_,__,___) => const BookListScreen(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero)); break;
         case 2: debugPrint("Navigate to Bookmark (Index 2) - Implement navigation"); break; // Add BookmarkScreen navigation if needed
         case 3: break; // Already here
       }
     }
  }

  @override
  Widget build(BuildContext context) {
    final double avatarRadius = 50.0;
    final double bottomNavBarEstimateHeight = 70.0;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double manualAppBarContentHeight = 56.0;

    final double avatarTopPosition = statusBarHeight + manualAppBarContentHeight + 10.0;
    final double contentContainerTopPosition = avatarTopPosition + avatarRadius;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
         statusBarColor: Colors.transparent,
         statusBarIconBrightness: Brightness.light,
         statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[

            // Layer 1: Background
            Container(color: primaryColor),

            // Layer 2: Main Rounded Content Area
            Positioned(
              top: contentContainerTopPosition, left: 0, right: 0, bottom: 0,
              child: ClipRRect(
                 borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), topRight: Radius.circular(60.0)),
                child: Container(
                  color: const Color(0xFF0A0A32), // Use primary color for the content background too
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: avatarRadius + 15.0,
                      bottom: bottomNavBarEstimateHeight + 10.0,
                      left: 20.0, right: 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Profile Info
                        Text('Ahlem Boudaoud', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor), textAlign: TextAlign.center),
                        SizedBox(height: 8),
                        Text('ahlemboudaoud@gmail.com', style: TextStyle(fontSize: 20, color: subduedTextColor), textAlign: TextAlign.center),
                        SizedBox(height: 70),
                        // --- List Items ---
                        // Calls to _buildProfileListItem now handle navigation internally via onTap
                        _buildProfileListItem(context, Icons.person_outline, 'Personnal infos', accentColor, textColor, subduedIconColor),
                        _buildProfileListItem(context, Icons.badge, 'Library card', accentColor, textColor, subduedIconColor), 
                        _buildProfileListItem(context, Icons.history, 'History', accentColor, textColor, subduedIconColor),
                        _buildProfileListItem(context, Icons.list_alt, 'book loan list', accentColor, textColor, subduedIconColor),
                        _buildProfileListItem(context, Icons.checklist_rtl, 'Wishlist', accentColor, textColor, subduedIconColor),
                        _buildProfileListItem(context, Icons.chat_bubble_outline, 'Admin Chat', accentColor, textColor, subduedIconColor),
                      ],
                    ),
                  ),
                ),
              ),
            ), // End Layer 2

            // Layer 3: Manual "AppBar" Content
            Positioned(
              top: statusBarHeight, left: 0, right: 0, height: manualAppBarContentHeight,
              child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: accentColor),
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmLogoutScreen()));
                      },
                    ),
                    Flexible(
                      child: Text('Profile', style: TextStyle(color: textColor, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: accentColor),
                      // Navigate to Notifications screen
                      onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserNotifScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ), // End Layer 3

            // Layer 4: Avatar
            Positioned(
              top: avatarTopPosition,
              child: CircleAvatar(radius: avatarRadius, backgroundColor: accentColor),
            ), // End Layer 4


            // Layer 5: Custom Bottom Navigation Bar
            Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(120.0),
                topRight: Radius.circular(120.0),
              ),
              child: BottomAppBar(
                shape: CircularNotchedRectangle(),
                notchMargin: 5.0,
                color: const Color.fromARGB(200, 10, 15, 58),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                         padding: const EdgeInsets.only(right: 0.0,left:5.0),
                        icon: Image.asset(
                          'assets/images/white_logo.png', // Path to your image
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
                        icon: Icon(Icons.menu_book_sharp, color: _selectedIndex == 1 ? Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                        onPressed: () => _onItemTapped(1),
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline, color: _selectedIndex == 2 ? Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
                        onPressed: (){
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
                        icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? Color.fromARGB(255, 165, 133, 36) : Colors.white, size: 30),
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
          ), // End Layer 5

          ], // End Stack Children
        ), // End Stack
      ), // End AnnotatedRegion
    ); // End Scaffold
  }

  // --- UPDATED Helper widget to handle navigation ---
  Widget _buildProfileListItem(
      BuildContext context, // Need context for Navigator
      IconData icon,
      String title,
      Color iconColor,
      Color mainTextColor,
      Color subduedChevronColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 32),
      title: Text(title, style: TextStyle(color: mainTextColor, fontSize: 20)),
      trailing: Icon(Icons.chevron_right, color: accentColor, size: 26), // Using accent color for chevron
      onTap: () {
        // Navigation logic based on the list item title
        Widget? targetScreen; // Use nullable Widget type

        // Determine the target screen based on the title
        // !! REPLACE THESE WITH YOUR ACTUAL SCREEN WIDGETS !!
        switch (title) {
          case 'Personnal infos':
            targetScreen = const ProfileSettingsScreen(); // Assumes PersonalInfoScreen is imported
            break;
          case 'Library card':
            targetScreen = const CardScreen(); // Assumes LibraryCardScreen is imported
            break;
          case 'History':
            targetScreen = const HistoryScreen(); // Assumes HistoryScreen is imported
            break;
           case 'book loan list':
             // Maybe this should navigate to BookListScreen? Or a specific loan list screen?
            targetScreen = const BookListScreen(); // Assumes BookLoanListScreen is imported
              break;
          case 'Wishlist':
            targetScreen = const WishListScreen(); // Assumes WishlistScreen is imported
            break;
          case 'Admin Chat':
            targetScreen = const AdminChatScreen(); // Assumes ChatBoxScreen is imported
            break;
          default:
            // Optional: Handle titles that don't match known screens
            debugPrint('Tapped on $title - No specific navigation defined.');
        }

        // Perform navigation if a target screen was determined
        if (targetScreen != null) {
          Navigator.push( // Use push to allow back navigation
            context,
            MaterialPageRoute(builder: (context) => targetScreen!),
          );
        } else {
           debugPrint('Tapped on $title, but targetScreen was null.');
        }
      },
    );
  }
} // End _ProfileScreenState