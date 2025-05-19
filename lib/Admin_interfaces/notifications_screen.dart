import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import for Timer
import 'dart:math'; // Import for random simulation

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showMessaging = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();

  // Simulate the current logged-in user ID (assuming it's an admin ID)
  final String _currentUserId = 'admin_user_me';
  final String _currentUserName = 'Admin Moi'; // Name for the logged-in admin

  // Liste simulée de messages pour la démonstration
  // Note: Cette liste est stockée en mémoire et ne persiste pas entre les sessions de l'application.
  // Pour une persistance réelle (comme Instagram), une base de données locale ou distante serait nécessaire.
  // isCurrentUser: true si le message est envoyé par l'utilisateur connecté (l'admin).
  // isStaff: true si l'expéditeur est un membre du personnel (admin ou le logged-in admin).
  final List<Map<String, dynamic>> _messages = [
    // Messages from a regular user to admin
    {
    'senderId': 'user1',
    'senderName': 'User Alpha',
    'message': 'Hello, I have a problem with my account.',
    'time': 'Yesterday 2:00 PM',
    'isCurrentUser': false,
    'isStaff': false,
    'id': 'msg_user1_1',
  },
  {
    'senderId': 'admin_user_me',
    'senderName': 'Admin Me',
    'message': 'Hello User Alpha, how can I help you?',
    'time': 'Yesterday 2:05 PM',
    'isCurrentUser': true,
    'isStaff': true,
    'id': 'msg_admin_me_1',
  },
  {
    'senderId': 'user1',
    'senderName': 'User Alpha',
    'message': "I can't renew a book.",
    'time': 'Yesterday 2:10 PM',
    'isCurrentUser': false,
    'isStaff': false,
    'id': 'msg_user1_2',
  },
  {
    'senderId': 'admin2',
    'senderName': 'Admin Beta',
    'message': 'Hi Admin Me, did you see the new procedure for borrowing?',
    'time': 'This morning 9:30 AM',
    'isCurrentUser': false,
    'isStaff': true,
    'id': 'msg_admin2_1',
  },
  {
    'senderId': 'admin_user_me',
    'senderName': 'Admin Me',
    'message': "Yes, I'm reading it. It seems more efficient.",
    'time': 'This morning 9:35 AM',
    'isCurrentUser': true,
    'isStaff': true,
    'id': 'msg_admin_me_2',
  },
  {
    'senderId': 'admin2',
    'senderName': 'Admin Beta',
    'message': 'Indeed. We should discuss it during the meeting.',
    'time': 'This morning 9:40 AM',
    'isCurrentUser': false,
    'isStaff': true,
    'id': 'msg_admin2_2',
  },
  ];

  // Liste simulée de notifications pour la démonstration
  // Note: Cette liste est stockée en mémoire et ne persiste pas entre les sessions de l'application.
  // Pour une persistance réelle (comme Instagram), une base de données locale ou distante serait nécessaire.
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'type': 'return',
      'title': 'Book Return Reminder',
      'message': 'The book "1984" is due to be returned tomorrow.',
      'time': '2h ago',
      'isRead': false,
      'details':
          'The book "1984" is due to be returned tomorrow. Otherwise you will have to coontact the user!',
      'id': 'notif_return_1', // Added unique ID
    },
    {
      'type': 'new',
      'title': 'New Book Added',
      'message':
          'A new book "Dune" has been added to the Science Fiction category.',
      'time': '1d ago',
      'isRead': false,
      'details':
          'The classic sci-fi novel "Dune" by Frank Herbert has been added to our collection. You can find it in the Science Fiction section, shelf B3.',
      'id': 'notif_new_1', // Added unique ID
    },
    {
      'type': 'system',
      'title': 'System Maintenance',
      'message':
          'The library system will be under maintenance tonight from 22:00 to 23:00.',
      'time': '2d ago',
      'isRead': true,
      'details':
          'During the maintenance period, online services including the catalog search and reservation system will be unavailable. We apologize for any inconvenience caused.',
      'id': 'notif_system_1', // Added unique ID
    },
    // New User Registration Notification Example (Unread)
    {
      'type': 'new_user',
      'title': 'New User Registration',
      'message': 'A new user has registered and awaits confirmation.',
      'time': '10m ago',
      'isRead': false,
      'details': {
        // Store user details in details map
        'fullName': 'Amine Benali',
        'email': 'amine.benali@example.com',
        'address': '123 Rue de l\'Indépendance, Alger',
        'ccp': '0078541258-65',
      },
      'id': 'notif_new_user_1',
      'needsAction': true, // Indicates admin action is needed
    },
    {
      'type': 'borrow_request',
      'title': 'Book Borrow Request',
      'message':
          'Sophie Martin wants to borrow "The Alchemist" by Paulo Coelho',
      'time': '3h ago',
      'isRead': false,
      'details':
          'User: Sophie Martin\nBook: The Alchemist\nAuthor: Paulo Coelho\nRequest Date: May 2, 2025\nAvailability: In Stock\nLocation: Section A, Shelf 3',
      'needsAction': true,
      'bookAvailable': true,
      'id': 'notif_borrow_1', // Added unique ID
    },
    // Example of a notification for a new message from a regular user (User-to-Admin)
    {
      "type": "chat_message",
      "title": "New Message from User Alpha",
      "message": "I can't renew a book.",
      "time": "Yesterday 2:10 PM",
      "isRead": false,
      "details": "Message in chat: I can't renew a book.",
      "relatedMessageId": "msg_user1_2",
      "id": "notif_chat_user_incoming"
   },

    // Example of a notification for a new message from another admin (Admin-to-Admin)
    {
      "type": "chat_message",
      "title": "New Message from Admin Beta",
      "message": "Indeed. We should discuss it during the meeting.",
      "time": "This morning 9:40 AM",
      "isRead": false,
      "details": "Message in chat: Indeed. We should discuss it during the meeting.",
      "relatedMessageId": "msg_admin2_2",
      "id": "notif_chat_admin_incoming"
    },
    {
      'type': 'borrow_request',
      'title': 'Book Borrow Request',
      'message': 'Thomas Dubois wants to borrow "Sapiens" by Yuval Noah Harari',
      'time': '1d ago',
      'isRead': false,
      'details':
          'User: Thomas Dubois\nBook: Sapiens\nAuthor: Yuval Noah Harari\nRequest Date: May 1, 2025\nAvailability: Not Available\nExpected Return Date: May 10, 2025',
      'needsAction': true,
      'bookAvailable': false,
      'id': 'notif_borrow_2', // Added unique ID
    },
    {
      'type': 'return',
      'title': 'Book Return Confirmation',
      'message': '"The Great Gatsby" is successfully returned.',
      'time': '5d ago',
      'isRead': true,
      'details':
          '"The Great Gatsby" by F. Scott Fitzgerald. The book was returned in good condition with no damage noted.',
      'id': 'notif_return_2', // Added unique ID
    },
    {
      'type': 'new',
      'title': 'New Collection Available',
      'message': 'A new collection of French literature classics is available.',
      'time': '1w ago',
      'isRead': true,
      'details':
          'A new collection of French literature classics including works by Victor Hugo, Albert Camus, and Simone de Beauvoir is added. Visit the second floor, west wing to check these titles.',
      'id': 'notif_new_2', // Added unique ID
    },
  ];

  List<Map<String, dynamic>> _filteredNotifications = [];

  // Simulate random sender for incoming messages
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Filtrer les notifications de type "fine" dès le départ (conserve l'intention d'origine)
    _allNotifications
        .removeWhere((notification) => notification['type'] == 'fine');

    // Sort notifications by time for better presentation (newest first)
    // For a real app, use actual timestamps for accurate sorting.
    _allNotifications.sort((a, b) {
      // Simple sorting based on a hypothetical chronological order if IDs were sequential,
      // or you could try to parse the 'time' strings (more complex).
      // Sticking to ID sorting for consistent demo order.
      return (b['id'] ?? '').compareTo(a['id'] ?? '');
    });

    _filteredNotifications = List.from(_allNotifications);

    // Simulate adding a new message and generating a notification after a delay
    Timer(const Duration(seconds: 3), () {
      _simulateIncomingMessage();
    });
  }

  void _simulateIncomingMessage() {
    if (mounted) {
      // Simulate message coming from a user or another admin
      final bool isFromUser =
          _random.nextBool(); // 50% chance from user, 50% from admin
      final String senderId = isFromUser
          ? 'user${_random.nextInt(100)}'
          : 'admin${_random.nextInt(100)}'; // Random user/admin ID
      final String senderName = isFromUser
          ? 'Utilisateur ${senderId.substring(4)}'
          : 'Admin ${senderId.substring(5)}'; // Generate a name
      final String messageContent = isFromUser
          ? 'Bonjour, j\'ai une question.'
          : 'Nouvelle mise à jour disponible.';

      final newMessage = {
        'senderId': senderId,
        'senderName': senderName,
        'message': messageContent,
        'time':
            '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'isCurrentUser': false, // Incoming message is never current user
        'isStaff': !isFromUser, // If not from user, it's staff
        'id':
            'msg_simulated_${_messages.length + 1}', // Simple unique ID for message
      };

      setState(() {
        _messages.add(newMessage);

        // Create a notification for this new incoming message
        // Add at the beginning to be easily visible in notifications list
        _allNotifications.insert(0, {
          'type': 'chat_message',
          'title': 'Nouveau message de ${newMessage['senderName']}',
          'message': newMessage['message'],
          'time': 'just now', // Could use actual time difference
          'isRead': false,
          'details': 'Message in chat: ${newMessage['message']}',
          'relatedMessageId': newMessage['id'],
          'id':
              'notif_chat_simulated_${_allNotifications.length + 1}', // Simple unique ID for notification
        });

        // Re-filter notifications based on the current tab
        _handleTabSelection();

        // Scroll to bottom of chat if messaging is open
        if (_showMessaging) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_chatScrollController.hasClients) {
              _chatScrollController.animateTo(
                _chatScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    }
  }

  // Placeholder function for handling new user confirmation/rejection
  void _handleNewUserRequest(Map<String, dynamic> notification, bool confirm) {
    setState(() {
      final originalIndex = _findNotificationIndexById(notification['id']);
      if (originalIndex != -1) {
        _allNotifications[originalIndex]['needsAction'] =
            false; // Mark action as taken
        _allNotifications[originalIndex]['isRead'] = true; // Mark as read

        // Update filtered list
        final filteredIndex = _filteredNotifications
            .indexWhere((item) => item['id'] == notification['id']);
        if (filteredIndex != -1) {
          _filteredNotifications[filteredIndex]['needsAction'] = false;
          _filteredNotifications[filteredIndex]['isRead'] = true;
          if (_tabController.index == 1) {
            // If on Unread tab, remove it
            _filteredNotifications.removeAt(filteredIndex);
          }
        }
      }
    });

    // In a real app, you would send this confirmation/rejection to your backend
    // For this demo, we just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          confirm
              ? 'New user ${notification['details']['fullName']} confirmed.'
              : 'New user ${notification['details']['fullName']} rejected.',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: confirm ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    print(
        '${confirm ? 'Confirmed' : 'Rejected'} user: ${notification['details']}');
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0: // All
            _filteredNotifications = List.from(_allNotifications);
            break;
          case 1: // Unread
            _filteredNotifications = _allNotifications
                .where((notification) => !notification['isRead'])
                .toList();
            break;
          case 2: // Read
            _filteredNotifications = _allNotifications
                .where((notification) => notification['isRead'])
                .toList();
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _chatScrollController.dispose();
    super.dispose();
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'return':
        return Icons.book;
      case 'new':
        return Icons.new_releases;
      case 'system':
        return Icons.system_update;
      case 'borrow_request':
        return Icons.book_online;
      case 'chat_message':
        return Icons.message;
      case 'new_user': // Icon for new user
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'return':
        return Colors.blueAccent;
      case 'new':
        return Colors.greenAccent;
      case 'system':
        return Colors.orangeAccent;
      case 'borrow_request':
        return Colors.purpleAccent;
      case 'chat_message':
        return Colors.tealAccent;
      case 'new_user': // Color for new user
        return Colors.blueGrey;
      default:
        return const Color(0xFFB19E44);
    }
  }

  // Helper to find the index in the full list based on ID
  int _findNotificationIndexById(String? id) {
    if (id == null) return -1;
    return _allNotifications
        .indexWhere((notification) => notification['id'] == id);
  }

  void _markAsRead(Map<String, dynamic> notificationToMark) {
    setState(() {
      final originalIndex =
          _findNotificationIndexById(notificationToMark['id']);

      if (originalIndex != -1) {
        _allNotifications[originalIndex]['isRead'] = true;

        // Update the filtered list separately if needed
        if (_tabController.index == 1) {
          // If on Unread tab, remove it
          _filteredNotifications.removeWhere(
              (notification) => notification['id'] == notificationToMark['id']);
        } else if (_tabController.index == 0) {
          // If on All tab, update the item in the filtered list
          final filteredIndex = _filteredNotifications.indexWhere(
              (notification) => notification['id'] == notificationToMark['id']);
          if (filteredIndex != -1) {
            _filteredNotifications[filteredIndex]['isRead'] = true;
          }
        }
        // If on Read tab, no change needed in filtered list as it was already there (or would be added if not there)
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _allNotifications) {
        notification['isRead'] = true;
      }

      // If on the "Unread" tab, clear the filtered list
      if (_tabController.index == 1) {
        _filteredNotifications.clear();
      } else if (_tabController.index == 0 || _tabController.index == 2) {
        // If on "All" or "Read" tab, update the filtered list
        for (final notification in _filteredNotifications) {
          notification['isRead'] = true;
        }
      }
    });
  }

  void _deleteNotification(Map<String, dynamic> notificationToDelete) {
    setState(() {
      final originalIndex =
          _findNotificationIndexById(notificationToDelete['id']);

      if (originalIndex != -1) {
        // Store the notification and its index for potential UNDO
        final deletedNotification =
            Map<String, dynamic>.from(_allNotifications[originalIndex]);
        final deletedAtIndex = originalIndex;

        _allNotifications.removeAt(originalIndex);
        _filteredNotifications.removeWhere(
            (notification) => notification['id'] == notificationToDelete['id']);

        // Show a snackbar to inform the user and provide UNDO
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification deleted',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFF1E2A3B),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'UNDO',
              textColor: const Color(0xFFB19E44),
              onPressed: () {
                // Logic to undo deletion
                setState(() {
                  _allNotifications.insert(deletedAtIndex, deletedNotification);
                  // Re-filter based on the current tab to restore in the correct filtered list
                  _handleTabSelection();
                });
              },
            ),
          ),
        );
      }
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    final newMessage = {
      'senderId': _currentUserId,
      'senderName': _currentUserName,
      'message': message.trim(),
      'time':
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'isCurrentUser': true,
      'isStaff': true, // Logged-in admin is staff
      'id':
          'msg_admin_me_${_messages.length + 1}', // Simple unique ID for message
    };

    setState(() {
      _messages.add(newMessage);

      // Optional: Create a notification for an outgoing admin message?
      // This is less common, usually users don't get notifications for messages they sent.
      // If needed, uncomment and adjust the notification details.
      /*
      _allNotifications.insert(0, {
          'type': 'chat_message',
          'title': 'Message sent (Admin)',
          'message': 'You: ${newMessage['message']}',
          'time': 'just now',
          'isRead': true, // Typically marked as read immediately since you sent it
          'details': 'Message in chat: ${newMessage['message']}',
          'relatedMessageId': newMessage['id'],
          'id': 'notif_chat_admin_outgoing_${_allNotifications.length + 1}',
      });
      _handleTabSelection(); // Re-filter if adding this notification
      */
    });

    _messageController.clear();

    // Scroll to bottom after sending message
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate an incoming response (from a user or another admin) after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      _simulateIncomingMessage();
    });
  }

  void _handleBorrowRequest(Map<String, dynamic> notification, bool approve) {
    setState(() {
      final originalIndex = _findNotificationIndexById(notification['id']);

      if (originalIndex != -1) {
        _allNotifications[originalIndex]['needsAction'] = false;
        _allNotifications[originalIndex]['isRead'] = true;

        // Update the filtered list as well
        final filteredIndex = _filteredNotifications
            .indexWhere((item) => item['id'] == notification['id']);
        if (filteredIndex != -1) {
          _filteredNotifications[filteredIndex]['needsAction'] = false;
          _filteredNotifications[filteredIndex]['isRead'] = true;
          // If on Unread tab, remove the item since it's now read
          if (_tabController.index == 1) {
            _filteredNotifications.removeAt(filteredIndex);
          }
        }
      }
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          approve
              ? 'Book borrow request has been approved'
              : 'Book borrow request has been rejected',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: approve ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showNotificationDetails(Map<String, dynamic> notification) {
    // If it's a chat message notification, open the chat instead
    if (notification['type'] == 'chat_message') {
      _markAsRead(notification); // Mark as read when opened
      setState(() {
        _showMessaging = true;
      });
      // Scroll to bottom of chat
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
      return; // Stop here, don't show the bottom sheet for chat messages
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2A3B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          // Use a Column and wrap with SingleChildScrollView to avoid overflow
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          _getNotificationColor(notification['type'])
                              .withOpacity(0.2),
                      child: Icon(
                        _getNotificationIcon(notification['type']),
                        color: _getNotificationColor(notification['type']),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  notification['time'],
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24),

                // Display different details based on notification type
                if (notification['type'] == 'new_user')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Details:',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Full Name: ${notification['details']['fullName']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email: ${notification['details']['email']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Address: ${notification['details']['address']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CCP Account: ${notification['details']['ccp']}',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    notification['details'] ?? notification['message'],
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 24),

                // Action buttons based on notification type and needsAction flag
                if (notification['type'] == 'borrow_request' &&
                    notification['needsAction'] == true)
                  Row(
                    // Borrow Request Action Buttons
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (notification['bookAvailable'] == true)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                _handleBorrowRequest(notification, true);
                              },
                              child: Text(
                                'Approve Request',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: notification['bookAvailable'] == true
                                  ? 8.0
                                  : 0.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _handleBorrowRequest(notification, false);
                            },
                            child: Text(
                              'Reject Request',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (notification['type'] == 'new_user' &&
                    notification['needsAction'] == true)
                  Row(
                    // New User Registration Action Buttons
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _handleNewUserRequest(
                                  notification, true); // Confirm
                            },
                            child: Text(
                              'Confirm User',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _handleNewUserRequest(
                                  notification, false); // Reject
                            },
                            child: Text(
                              'Reject User',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                // Bouton pour fermer la modale
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFB19E44),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagingInterface() {
    // Check if the messaging interface is meant to be shown
    if (!_showMessaging) {
      return const SizedBox.shrink(); // Return an empty box if not visible
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2A3B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF121921),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages', // General title for admin view
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showMessaging = false;
                    });
                  },
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final bool isCurrentUser = message['isCurrentUser'];

                return Align(
                  alignment: isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Use min to wrap content
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar for incoming messages (from users or other admins)
                        if (!isCurrentUser)
                          CircleAvatar(
                            backgroundColor: message['isStaff']!
                                ? Colors.blueGrey
                                : Colors
                                    .deepOrange, // Different color for users vs other staff
                            radius: 16, // Adjusted size
                            child: Text(
                              message['senderName'][0]
                                  .toUpperCase(), // First letter of sender name
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14), // Adjusted font size
                            ),
                          ),
                        if (!isCurrentUser) const SizedBox(width: 8),

                        // Message Bubble
                        Flexible(
                          // Use Flexible to prevent overflow if text is long
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            // Removed maxWidth constraint to let Flexible manage width
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? const Color(0xFFB19E44)
                                      .withOpacity(0.8) // Logged-in admin color
                                  : message['isStaff']!
                                      ? const Color(0xFF2A3B4E)
                                      : const Color(
                                          0xFF4E3A2A), // Other admin vs User color
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(isCurrentUser ? 16 : 0),
                                topRight:
                                    Radius.circular(isCurrentUser ? 0 : 16),
                                bottomLeft: const Radius.circular(16),
                                bottomRight: const Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display sender name if it's an incoming message
                                if (!isCurrentUser)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      message['senderName'],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                Text(
                                  message['message'],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message['time'],
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Avatar for outgoing messages (from the logged-in admin)
                        if (isCurrentUser) const SizedBox(width: 8),
                        if (isCurrentUser)
                          CircleAvatar(
                            backgroundColor: Colors
                                .blueGrey, // Color for the logged-in admin
                            radius: 16, // Adjusted size
                            child: Text(
                              _currentUserName[0]
                                  .toUpperCase(), // Use first letter of user name
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14), // Adjusted font size
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF121921),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: GoogleFonts.montserrat(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.montserrat(color: Colors.white60),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF2A3B4E),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFB19E44),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text(
          'Notifications',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () {
              setState(() {
                _showMessaging = true;
              });
              // Scroll to bottom when showing messaging
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_chatScrollController.hasClients) {
                  _chatScrollController.animateTo(
                    _chatScrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              });
            },
            tooltip: 'Open Messages', // Tooltip adjusted for admin view
          ),
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white),
            onPressed:
                _allNotifications.any((notification) => !notification['isRead'])
                    ? _markAllAsRead
                    : null,
            tooltip: 'Mark all as read',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFB19E44),
          labelColor: const Color(0xFFB19E44),
          unselectedLabelColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
            Tab(text: 'Read'),
          ],
          labelStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // Contenu identique, la différence est gérée par la liste filtrée
              _buildNotificationsList(),
              _buildNotificationsList(),
              _buildNotificationsList(),
            ],
          ),

          // Interface de messagerie - Positioned to slide up from the bottom
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: 0,
            right: 0,
            bottom: _showMessaging
                ? 0
                : -MediaQuery.of(context).size.height * 0.7, // Slide up or down
            child: _buildMessagingInterface(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    if (_filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.notifications_off,
              color: Colors.white30,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        final bool isUnread = !notification['isRead'];
        final bool needsAction = notification['needsAction'] ?? false;

        // Use a combination of ID and index as a fallback key
        final itemKey = ValueKey(notification['id'] ??
            '${notification['title']}_${notification['time']}_$index');

        return Dismissible(
          key: itemKey,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteNotification(notification);
            // Snackbar logic moved inside _deleteNotification
          },
          child: Card(
            color: isUnread
                ? const Color(0xFF1E2A3B)
                : const Color(0xFF1E2A3B).withOpacity(0.7),
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: isUnread
                  ? const BorderSide(color: Color(0xFFB19E44), width: 1.0)
                  : BorderSide.none,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: _getNotificationColor(notification['type'])
                    .withOpacity(0.2),
                child: Icon(
                  _getNotificationIcon(notification['type']),
                  color: _getNotificationColor(notification['type']),
                ),
              ),
              title: Text(
                notification['title'],
                style: GoogleFonts.montserrat(
                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // Display a generic message preview for new user notifications in the list
                  notification['type'] == 'new_user'
                      ? Text(
                          notification['message'],
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )
                      : Text(
                          notification['message'],
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        notification['time'],
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (needsAction)
                        Text(
                          'Action Required',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              trailing: isUnread &&
                      notification['type'] !=
                          'chat_message' // Don't show mark as read for chat notifs here
                  ? IconButton(
                      icon: const Icon(
                        Icons.mark_email_read,
                        color: Color(0xFFB19E44),
                      ),
                      onPressed: () => _markAsRead(notification),
                      tooltip: 'Mark as read',
                    )
                  : const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white30,
                      size: 16,
                    ),
              onTap: () {
                // Mark as read when tapped, unless it's a chat message handled by _showNotificationDetails
                if (isUnread && notification['type'] != 'chat_message') {
                  _markAsRead(notification);
                }
                _showNotificationDetails(
                    notification); // This will now handle different types
              },
            ),
          ),
        );
      },
    );
  }
}
