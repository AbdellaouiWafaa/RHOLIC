import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async'; // Import for Timer
import 'dart:math'; // Import for random simulation
// Import necessary packages for opening URLs (for the document preview simulation)
import 'package:url_launcher/url_launcher.dart';

<<<<<<< HEAD
class DummyUserData {
  // Use a static list to simulate data storage across the application
  static final List<Map<String, dynamic>> _existingUsers = [
    // Example of existing users - Add users here initially or via DummyUserData.addUser()
    {
      'fullName': 'Existing User One',
      'email': 'user1@example.com',
      'id': 'user_existing_1',
    },
    {
      'fullName': 'Existing User Two',
      'email': 'user2@example.com',
      'id': 'user_existing_2',
    },
    {
      'fullName': 'Admin Beta',
      'email': 'admin.beta@example.com',
      'id': 'admin2',
      'isAdmin': true,
    },
    {
      'fullName': 'Admin Charlie',
      'email': 'admin.charlie@example.com',
      'id': 'admin3',
      'isAdmin': true,
    },
  ];

  // Method to get existing users (for the placeholder ExistingUsersScreen)
  static List<Map<String, dynamic>> getExistingUsers() {
    return List.from(
      _existingUsers,
    ); // Return a copy to prevent external modification
  }

  // Method to get only admin users
  static List<Map<String, dynamic>> getAdminUsers() {
    return _existingUsers.where((user) => user['isAdmin'] == true).toList();
  }

  // Method to get only regular users
  static List<Map<String, dynamic>> getRegularUsers() {
    return _existingUsers.where((user) => user['isAdmin'] != true).toList();
  }
}

class NotificationsScreen extends StatefulWidget { 
  const NotificationsScreen({Key? key}) : super(key: key);
=======
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
>>>>>>> 5f3a6cf1e07751e46e55751a0eeb03174728805c

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
  
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  bool _showUserSelectionDialog = false; // Pour afficher la liste des utilisateurs
  List<Map<String, dynamic>> _selectedUsers = []; // Pour stocker les utilisateurs sélectionnés
  bool _selectAllUsers = false; 
  late TabController _tabController;
  bool _showMessaging = false;
  bool _showBroadcastDialog =
      false; // Pour gérer l'affichage du dialogue d'envoi de notifications
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _broadcastTitleController =
      TextEditingController(); // Pour le titre de la notification
  final TextEditingController _broadcastMessageController =
      TextEditingController(); // Pour le message de la notification
  final ScrollController _chatScrollController = ScrollController();

  // Pour la séparation des discussions
  String _selectedChatUserId =
      ''; // ID de l'utilisateur sélectionné pour la discussion
  String _selectedChatUserName =
      ''; // Nom de l'utilisateur sélectionné pour la discussion
  bool _isAdminChat =
      false; // Pour savoir si c'est une discussion avec un admin ou un utilisateur

  // Simulate the current logged-in user ID (assuming it's an admin ID)
  final String _currentUserId = 'admin_user_me';
  final String _currentUserName = 'Admin Moi'; // Name for the logged-in admin

  // Conversations (organisation des messages par utilisateur)
  Map<String, List<Map<String, dynamic>>> _conversations = {};

  // Liste simulée de messages pour la démonstration
  final List<Map<String, dynamic>> _messages = [
    // Messages from a regular user to admin
    {
      'senderId': 'user_existing_1',
      'senderName': 'Existing User One',
      'message': 'Hello, I have a problem with my account.',
      'time': 'Yesterday 2:00 PM',
      'isCurrentUser': false,
      'isStaff': false,
      'id': 'msg_user1_1',
    },
    {
      'senderId': 'admin_user_me',
      'senderName': 'Admin Me',
      'message': 'Hello User One, how can I help you?',
      'time': 'Yesterday 2:05 PM',
      'isCurrentUser': true,
      'isStaff': true,
      'id': 'msg_admin_me_1',
      'recipientId': 'user_existing_1', // Add recipient info
    },
    {
      'senderId': 'user_existing_1',
      'senderName': 'Existing User One',
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
      'recipientId': 'admin2', // Add recipient info
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
    // Messages from user two
    {
      'senderId': 'user_existing_2',
      'senderName': 'Existing User Two',
      'message': "Hello, I'm interested in a book about machine learning.",
      'time': 'Yesterday 3:30 PM',
      'isCurrentUser': false,
      'isStaff': false,
      'id': 'msg_user2_1',
    },
    {
      'senderId': 'admin_user_me',
      'senderName': 'Admin Me',
      'message':
          'We have several books on machine learning. What specific topic are you interested in?',
      'time': 'Yesterday 3:35 PM',
      'isCurrentUser': true,
      'isStaff': true,
      'id': 'msg_admin_me_3',
      'recipientId': 'user_existing_2', // Add recipient info
    },
    // Messages from admin three
    {
      'senderId': 'admin3',
      'senderName': 'Admin Charlie',
      'message': 'Hello, we have a new shipment of books arriving next week.',
      'time': 'Today 10:15 AM',
      'isCurrentUser': false,
      'isStaff': true,
      'id': 'msg_admin3_1',
    },
    {
      'senderId': 'admin_user_me',
      'senderName': 'Admin Me',
      'message': 'Great! I will prepare the space in the storage room.',
      'time': 'Today 10:20 AM',
      'isCurrentUser': true,
      'isStaff': true,
      'id': 'msg_admin_me_4',
      'recipientId': 'admin3', // Add recipient info
    },
  ];

  // Liste simulée de notifications pour la démonstration
  final List<Map<String, dynamic>> _allNotifications = [
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
        'phone': '+213 123 456 789',
        'ccp': '0078541258-65',
        'documentName': 'Amine_Benali_ID.pdf', // Added document name
        // Use a placeholder URL for the document. A real app would need a valid URL.
        'documentUrl':
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
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
      "title": "New Message from User One",
      "message": "I can't renew a book.",
      "time": "Yesterday 2:10 PM",
      "isRead": false,
      "details": "Message in chat: I can't renew a book.",
      "relatedMessageId": "msg_user1_2",
      "senderId": "user_existing_1",
      "id": "notif_chat_user_incoming",
    },

    // Example of a notification for a new message from another admin (Admin-to-Admin)
    {
      "type": "chat_message",
      "title": "New Message from Admin Beta",
      "message": "Indeed. We should discuss it during the meeting.",
      "time": "This morning 9:40 AM",
      "isRead": false,
      "details":
          "Message in chat: Indeed. We should discuss it during the meeting.",
      "relatedMessageId": "msg_admin2_2",
      "senderId": "admin2",
      "id": "notif_chat_admin_incoming",
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
    _allNotifications.removeWhere(
      (notification) => notification['type'] == 'fine',
    );

    // Sort notifications by time for better presentation (newest first)
    _allNotifications.sort((a, b) {
      return (b['id'] ?? '').compareTo(a['id'] ?? '');
    });

    _filteredNotifications = List.from(_allNotifications);

    // Organize messages into conversations by user
    _organizeConversations();

    // Simulate adding a new message and generating a notification after a delay
    Timer(const Duration(seconds: 3), () {
      _simulateIncomingMessage();
    });
  }

  // Organize messages into conversations by sender/recipient
  void _organizeConversations() {
    _conversations = {};

    for (var message in _messages) {
      String conversationId;

      if (message['isCurrentUser']) {
        // For messages sent by current user, use recipient as conversation ID
        conversationId = message['recipientId'];
      } else {
        // For messages received, use sender as conversation ID
        conversationId = message['senderId'];
      }

      if (!_conversations.containsKey(conversationId)) {
        _conversations[conversationId] = [];
      }

      _conversations[conversationId]!.add(message);
    }

    // Sort each conversation by time (assuming message IDs are sequential)
    _conversations.forEach((key, messages) {
      messages.sort((a, b) => a['id'].compareTo(b['id']));
    });
  }

  void _simulateIncomingMessage() {
    if (mounted) {
      // Simulate message coming from a user or another admin
      final bool isFromUser =
          _random.nextBool(); // 50% chance from user, 50% from admin

      String senderId;
      String senderName;

      if (isFromUser) {
        // Get random user
        final allUsers = DummyUserData.getRegularUsers();
        final randomUser = allUsers[_random.nextInt(allUsers.length)];
        senderId = randomUser['id'];
        senderName = randomUser['fullName'];
      } else {
        // Get random admin
        final allAdmins = DummyUserData.getAdminUsers();
        final randomAdmin = allAdmins[_random.nextInt(allAdmins.length)];
        senderId = randomAdmin['id'];
        senderName = randomAdmin['fullName'];
      }

      final String messageContent =
          isFromUser
              ? 'Hi, I have a question about my account.'
              : 'New update about library operations.';

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

        // Add to conversations
        if (!_conversations.containsKey(senderId)) {
          _conversations[senderId] = [];
        }
        _conversations[senderId]!.add(newMessage);

        // Create a notification for this new incoming message
        _allNotifications.insert(0, {
          'type': 'chat_message',
          'title': 'New Message From ${newMessage['senderName']}',
          'message': newMessage['message'],
          'time': 'just now',
          'isRead': false,
          'details': 'Message in chat: ${newMessage['message']}',
          'relatedMessageId': newMessage['id'],
          'senderId': senderId,
          'id': 'notif_chat_simulated_${_allNotifications.length + 1}',
        });

        // Re-filter notifications based on the current tab
        _handleTabSelection();

        // If the messaging is open and showing the conversation with this sender,
        // scroll to the bottom
        if (_showMessaging && _selectedChatUserId == senderId) {
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

  // Fonction pour envoyer une notification à tous les utilisateurs
  void _sendBroadcastNotification(String title, String message) {
    if (title.isEmpty || message.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Title and message cannot be empty',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create new notification
    final newNotification = {
      'type': 'broadcast',
      'title': title,
      'message': message,
      'time': 'Just now',
      'isRead': false,
      'details': 'Broadcast message: $message',
      'id': 'notif_broadcast_${DateTime.now().millisecondsSinceEpoch}',
      'needsAction': false,
    };

    setState(() {
      // Add to notifications list
      _allNotifications.insert(0, newNotification);

      // Re-filter notifications based on the current tab
      _handleTabSelection();
    });

    // Reset text controllers
    _broadcastTitleController.clear();
    _broadcastMessageController.clear();

    // Close the dialog
    setState(() {
      _showBroadcastDialog = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Notification sent to all users',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
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
        final filteredIndex = _filteredNotifications.indexWhere(
          (item) => item['id'] == notification['id'],
        );
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
    // For this demo, we simulate adding the user to the dummy list if confirmed
    if (confirm) {
      // Simulate adding the user to the list that ExistingUsersScreen would display
      print('User ${notification['details']['fullName']} confirmed.');
    } else {
      print('User ${notification['details']['fullName']} rejected.');
    }

    // Show a snackbar
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
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0: // All
            _filteredNotifications = List.from(_allNotifications);
            break;
          case 1: // Unread
            _filteredNotifications =
                _allNotifications
                    .where((notification) => !notification['isRead'])
                    .toList();
            break;
          case 2: // Read
            _filteredNotifications =
                _allNotifications
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
    _broadcastTitleController.dispose();
    _broadcastMessageController.dispose();
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
      case 'broadcast': // Icon for broadcast messages
        return Icons.campaign;
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
      case 'broadcast': // Color for broadcast messages
        return Colors.deepPurpleAccent;
      default:
        return const Color(0xFFB19E44);
    }
  }

  // Helper to find the index in the full list based on ID
  int _findNotificationIndexById(String? id) {
    if (id == null) return -1;
    return _allNotifications.indexWhere(
      (notification) => notification['id'] == id,
    );
  }

  void _markAsRead(Map<String, dynamic> notificationToMark) {
    // Check if the notification is already read to avoid unnecessary setState calls
    if (notificationToMark['isRead']) return;

    setState(() {
      final originalIndex = _findNotificationIndexById(
        notificationToMark['id'],
      );

      if (originalIndex != -1) {
        _allNotifications[originalIndex]['isRead'] = true;

        // Update the filtered list separately if needed
        // If on Unread tab, remove it
        _filteredNotifications.removeWhere(
          (notification) => notification['id'] == notificationToMark['id'],
        );

        // If on All tab, update the item in the filtered list if it exists
        final filteredIndex = _filteredNotifications.indexWhere(
          (notification) => notification['id'] == notificationToMark['id'],
        );
        if (filteredIndex != -1) {
          _filteredNotifications[filteredIndex]['isRead'] = true;
        }

        // If on Read tab, the item will be added if it wasn't there before
      }
    });
    print('Notification marked as read: ${notificationToMark['title']}');
    // After marking as read, re-filter the list based on the current tab
    // This ensures the UI updates correctly, especially for the Unread tab
    _handleTabSelection();
  }

  void _markAllAsRead() {
    setState(() {
      bool changed = false;
      for (final notification in _allNotifications) {
        if (!notification['isRead']) {
          notification['isRead'] = true;
          changed = true;
        }
      }
      if (changed) {
        print('All notifications marked as read.');
        // Re-filter based on the current tab to update the UI
        _handleTabSelection();
      } else {
        print('No unread notifications to mark.');
      }
    });
  }

  void _deleteNotification(Map<String, dynamic> notificationToDelete) {
    setState(() {
      final originalIndex = _findNotificationIndexById(
        notificationToDelete['id'],
      );

      if (originalIndex != -1) {
        // Store the notification and its index for potential UNDO
        final deletedNotification = Map<String, dynamic>.from(
          _allNotifications[originalIndex],
        );
        final deletedAtIndex = originalIndex;

        _allNotifications.removeAt(originalIndex);
        _filteredNotifications.removeWhere(
          (notification) => notification['id'] == notificationToDelete['id'],
        );

        print('Notification deleted: ${notificationToDelete['title']}');

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
                  // Re-insert the deleted notification at its original index
                  _allNotifications.insert(deletedAtIndex, deletedNotification);
                  print('Notification deletion undone.');
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

  void _openChat(String userId, String userName, bool isAdmin) {
    // If notification is for a chat message, open that specific conversation
    setState(() {
      _selectedChatUserId = userId;
      _selectedChatUserName = userName;
      _isAdminChat = isAdmin;
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
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty || _selectedChatUserId.isEmpty) return;

    final newMessage = {
      'senderId': _currentUserId,
      'senderName': _currentUserName,
      'message': message.trim(),
      'time':
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'isCurrentUser': true,
      'isStaff': true, // Logged-in admin is staff
      'id': 'msg_admin_me_${DateTime.now().millisecondsSinceEpoch}',
      'recipientId': _selectedChatUserId, // Add recipient info
    };

    setState(() {
      _messages.add(newMessage);

      // Add to conversations
      if (!_conversations.containsKey(_selectedChatUserId)) {
        _conversations[_selectedChatUserId] = [];
      }
      _conversations[_selectedChatUserId]!.add(newMessage);

      print('Sent message: ${newMessage['message']}');
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

    // Simulate an incoming response after a short delay
    if (_random.nextBool()) {
      // 50% chance to get a response
      Future.delayed(const Duration(seconds: 2), () {
        _simulateResponseMessage(
          _selectedChatUserId,
          _selectedChatUserName,
          _isAdminChat,
        );
      });
    }
  }

  void _simulateResponseMessage(
    String senderId,
    String senderName,
    bool isAdmin,
  ) {
    if (!mounted) return;

    // Create a response message
    final String messageContent =
        isAdmin
            ? 'I\'ll check the records and get back to you.'
            : 'Thank you for your assistance.';

    final newMessage = {
      'senderId': senderId,
      'senderName': senderName,
      'message': messageContent,
      'time':
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'isCurrentUser': false,
      'isStaff': isAdmin,
      'id': 'msg_response_${_messages.length + 1}',
    };

    setState(() {
      _messages.add(newMessage);

      // Add to conversations
      if (!_conversations.containsKey(senderId)) {
        _conversations[senderId] = [];
      }
      _conversations[senderId]!.add(newMessage);

      // If this is the active conversation, scroll to bottom
      if (_selectedChatUserId == senderId && _showMessaging) {
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

  void _handleBorrowRequest(Map<String, dynamic> notification, bool approve) {
    setState(() {
      final originalIndex = _findNotificationIndexById(notification['id']);

      if (originalIndex != -1) {
        _allNotifications[originalIndex]['needsAction'] = false;
        _allNotifications[originalIndex]['isRead'] = true;

        final filteredIndex = _filteredNotifications.indexWhere(
          (item) => item['id'] == notification['id'],
        );
        if (filteredIndex != -1) {
          _filteredNotifications[filteredIndex]['needsAction'] = false;
          _filteredNotifications[filteredIndex]['isRead'] = true;
          if (_tabController.index == 1) {
            _filteredNotifications.removeAt(filteredIndex);
          }
        }
      }
    });

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

  void _viewDocument(String? url) async {
    if (url != null && url.isNotEmpty) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open document: $url',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No document available for this user.',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildChatInterface() {
    if (!_showMessaging || _selectedChatUserId.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get messages for this conversation
    final conversationMessages = _conversations[_selectedChatUserId] ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2A3B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with back button and user info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF121921),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _showMessaging = false;
                      _selectedChatUserId = '';
                    });
                  },
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor:
                      _isAdminChat ? Colors.blueGrey : Colors.deepOrange,
                  child: Text(
                    _selectedChatUserName[0].toUpperCase(),
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedChatUserName,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isAdminChat ? 'Admin' : 'User',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _chatScrollController,
              padding: const EdgeInsets.all(16),
              itemCount: conversationMessages.length,
              itemBuilder: (context, index) {
                final message = conversationMessages[index];
                final bool isCurrentUser = message['isCurrentUser'];

                return Align(
                  alignment:
                      isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isCurrentUser)
                          CircleAvatar(
                            backgroundColor:
                                _isAdminChat
                                    ? Colors.blueGrey
                                    : Colors.deepOrange,
                            radius: 16,
                            child: Text(
                              message['senderName'][0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        if (!isCurrentUser) const SizedBox(width: 8),

                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isCurrentUser
                                      ? const Color(0xFFB19E44).withOpacity(0.8)
                                      : const Color(0xFF2A3B4E),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  isCurrentUser ? 16 : 0,
                                ),
                                topRight: Radius.circular(
                                  isCurrentUser ? 0 : 16,
                                ),
                                bottomLeft: const Radius.circular(16),
                                bottomRight: const Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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

                        if (isCurrentUser) const SizedBox(width: 8),
                        if (isCurrentUser)
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 16,
                            child: Text(
                              _currentUserName[0].toUpperCase(),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                              ),
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
                        horizontal: 20,
                        vertical: 12,
                      ),
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

  Widget _buildBroadcastDialog() {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E2A3B),
      title: Text(
        'Send Notification to All Users',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _broadcastTitleController,
            style: GoogleFonts.montserrat(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: GoogleFonts.montserrat(color: Colors.white70),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0xFF2A3B4E),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _broadcastMessageController,
            style: GoogleFonts.montserrat(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Message',
              labelStyle: GoogleFonts.montserrat(color: Colors.white70),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: const Color(0xFF2A3B4E),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showBroadcastDialog = false;
            });
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _sendBroadcastNotification(
              _broadcastTitleController.text,
              _broadcastMessageController.text,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB19E44),
          ),
          child: Text(
            'Send',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
      ],
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

        final itemKey = ValueKey(
          notification['id'] ??
              '${notification['title']}_${notification['time']}_$index',
        );

        return Dismissible(
          key: itemKey,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteNotification(notification);
          },
          child: Card(
            color:
                isUnread
                    ? const Color(0xFF1E2A3B)
                    : const Color(0xFF1E2A3B).withOpacity(0.7),
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side:
                  isUnread
                      ? const BorderSide(color: Color(0xFFB19E44), width: 1.0)
                      : BorderSide.none,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: CircleAvatar(
                backgroundColor: _getNotificationColor(
                  notification['type'],
                ).withOpacity(0.2),
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
                  if (notification['type'] == 'new_user')
                    Text(
                      'New user: ${notification['details']['fullName'] ?? 'N/A'}',
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    )
                  else
                    Text(
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
              trailing:
                  isUnread && notification['type'] != 'chat_message'
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
                if (notification['type'] == 'chat_message') {
                  // Open the chat with this user/admin
                  _markAsRead(notification);
                  _openChat(
                    notification['senderId'],
                    notification['title'].replaceFirst('New Message from ', ''),
                    notification['title'].contains('Admin'),
                  );
                } else {
                  _showNotificationDetails(notification);
                }
              },
            ),
          ),
        );
      },
    );
  }

  // Show notification details in a dialog
  void _showNotificationDetails(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2A3B),
          title: Text(
            notification['title'] ?? 'Notification Details',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification['type'] == 'new_user' &&
                    notification['details'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name: ${notification['details']['fullName'] ?? 'N/A'}',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        'Email: ${notification['details']['email'] ?? 'N/A'}',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        'Address: ${notification['details']['address'] ?? 'N/A'}',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        'Phone: ${notification['details']['phone'] ?? 'N/A'}',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        'CCP: ${notification['details']['ccp'] ?? 'N/A'}',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      if (notification['details']['documentUrl'] != null)
                        TextButton.icon(
                          icon: const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.white,
                          ),
                          label: Text(
                            'View Document',
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                          onPressed:
                              () => _viewDocument(
                                notification['details']['documentUrl'],
                              ),
                        ),
                    ],
                  )
                else if (notification['details'] != null)
                  Text(
                    notification['details'].toString(),
                    style: GoogleFonts.montserrat(color: Colors.white70),
                  )
                else
                  Text(
                    notification['message'] ?? '',
                    style: GoogleFonts.montserrat(color: Colors.white70),
                  ),
              ],
            ),
          ),
          actions: [
            if (notification['type'] == 'new_user' &&
                (notification['needsAction'] ?? false))
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleNewUserRequest(notification, false);
                    },
                    child: Text(
                      'Reject',
                      style: GoogleFonts.montserrat(color: Colors.redAccent),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleNewUserRequest(notification, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB19E44),
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                ],
              )
            else if (notification['type'] == 'borrow_request' &&
                (notification['needsAction'] ?? false))
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleBorrowRequest(notification, false);
                    },
                    child: Text(
                      'Reject',
                      style: GoogleFonts.montserrat(color: Colors.redAccent),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _handleBorrowRequest(notification, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB19E44),
                    ),
                    child: Text(
                      'Approve',
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                ],
              )
            else
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
          ],
        );
      },
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign, color: Colors.white),
            onPressed: () {
              setState(() {
                _showBroadcastDialog = true;
                _showMessaging = false;
              });
            },
            tooltip: 'Broadcast notification',
          ),
          IconButton(
            icon: const Icon(Icons.message, color: Colors.white),
            onPressed: () {
              setState(() {
                _showMessaging = !_showMessaging;
                if (_showMessaging) {
                  // Default to showing admin chats when opening messaging
                  _selectedChatUserId = 'admin2';
                  _selectedChatUserName = 'Admin Beta';
                  _isAdminChat = true;
                }
              });
            },
            tooltip: 'Open Messages',
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
              _buildNotificationsList(),
              _buildNotificationsList(),
              _buildNotificationsList(),
            ],
          ),

          // Chat Interface
          if (_showMessaging) _buildChatInterface(),

          // Broadcast Dialog
          if (_showBroadcastDialog) Center(child: _buildBroadcastDialog()),
        ],
      ),
    );
  }
}
