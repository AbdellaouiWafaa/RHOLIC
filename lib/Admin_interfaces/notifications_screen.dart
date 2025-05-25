import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'manageMain_screen.dart'; // Import the manage screen

class DummyUserData {
  static final List<Map<String, dynamic>> _existingUsers = [
    {
      'fullName': 'User One',
      'email': 'user1@example.com',
      'id': 'user_existing_1',
    },
    {
      'fullName': 'User Two',
      'email': 'user2@example.com',
      'id': 'user_existing_2',
    },
  ];

  static final List<Map<String, dynamic>> _adminUsers = [
    {'fullName': 'Admin Beta', 'email': 'admin2@example.com', 'id': 'admin2'},
    {
      'fullName': 'Admin Charlie',
      'email': 'admin3@example.com',
      'id': 'admin3',
    },
    {
      'fullName': 'Admin Moi',
      'email': 'admin_me@example.com',
      'id': 'admin_user_me',
    },
  ];

  static List<Map<String, dynamic>> getExistingUsers() {
    return List.from(_existingUsers);
  }

  static List<Map<String, dynamic>> getRegularUsers() {
    // Return users that are not admins
    return List.from(_existingUsers);
  }

  static List<Map<String, dynamic>> getAdminUsers() {
    return List.from(_adminUsers);
  }

  static void addUser(Map<String, dynamic> user) {
    _existingUsers.add(user);
  }
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  bool _showUserSelectionDialog =
      false; // Pour afficher la liste des utilisateurs
  List<Map<String, dynamic>> _selectedUsers =
      []; // Pour stocker les utilisateurs sélectionnés
  bool _selectAllUsers = false; // Pour sélectionner tous les utilisateurs
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

  // méthode _sendBroadcastNotification pour prendre en compte les utilisateurs sélectionnés
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
      'recipients':
          _selectedUsers.isEmpty
              ? 'All Users'
              : '${_selectedUsers.length} Selected Users',
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
      _selectedUsers =
          []; // Réinitialiser la liste des utilisateurs sélectionnés
      _selectAllUsers = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedUsers.isEmpty
              ? 'Notification sent to all selected users'
              : 'Notification sent to ${_selectedUsers.length} users',
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

  // Ajoutez cette méthode pour construire le dialogue de sélection des utilisateurs
  Widget _buildUserSelectionDialog() {
    // Obtenez la liste de tous les utilisateurs réguliers (non-admin)
    final List<Map<String, dynamic>> allUsers = DummyUserData.getRegularUsers();

    return AlertDialog(
      backgroundColor: const Color(0xFF1E2A3B),
      title: Text(
        'Select Recipients',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            // Option to select all users
            CheckboxListTile(
              title: Text(
                'Select All Users',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: _selectAllUsers,
              activeColor: const Color(0xFFB19E44),
              checkColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _selectAllUsers = value ?? false;
                  if (_selectAllUsers) {
                    _selectedUsers = List.from(allUsers);
                  } else {
                    _selectedUsers = [];
                  }
                });
              },
            ),
            Divider(color: Colors.white30),
            Expanded(
              child: ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (context, index) {
                  final user = allUsers[index];
                  // Check if this user is already selected
                  final bool isSelected = _selectedUsers.any(
                    (selectedUser) => selectedUser['id'] == user['id'],
                  );

                  return CheckboxListTile(
                    title: Text(
                      user['fullName'] ?? 'Unknown User',
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                    subtitle: Text(
                      user['email'] ?? 'No email',
                      style: GoogleFonts.montserrat(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    value: isSelected,
                    activeColor: const Color(0xFFB19E44),
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        if (value ?? false) {
                          // Add to selected users if not already there
                          if (!isSelected) {
                            _selectedUsers.add(user);
                          }
                        } else {
                          // Remove from selected users
                          _selectedUsers.removeWhere(
                            (selectedUser) => selectedUser['id'] == user['id'],
                          );
                        }

                        // Update "select all" checkbox based on selection state
                        _selectAllUsers =
                            _selectedUsers.length == allUsers.length;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showUserSelectionDialog = false;
              _selectedUsers = [];
              _selectAllUsers = false;
            });
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _broadcastTitleController.clear();
              _broadcastMessageController.clear();
              _showUserSelectionDialog = false;
              _showBroadcastDialog = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB19E44),
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Placeholder function for handling new user confirmation/rejection
  void _handleNewUserRequest(Map<String, dynamic> notification, bool confirm) {
    if (confirm) {
      final userDetails = notification['details'];
      final newUser = {
        'id': userDetails['email'].replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'),
        'fullName': userDetails['fullName'],
        'email': userDetails['email'],
        'address': userDetails['address'],
        'phone': userDetails['phone'],
        'memberSince': DateTime.now().toString(),
        'isBlocked': false,
      };

      // Add to global user list
      DummyUserData.addUser(newUser);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User ${userDetails['fullName']} confirmed.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User ${notification['details']['fullName']} rejected.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      final index = _allNotifications.indexWhere(
        (n) => n['id'] == notification['id'],
      );
      if (index != -1) {
        _allNotifications[index]['needsAction'] = false;
        _allNotifications[index]['isRead'] = true;
        _handleTabSelection();
      }
    });
  }

  void _handleTabSelection() {
    setState(() {
      switch (_tabController.index) {
        case 0: // All - toutes les notifications
          _filteredNotifications = [..._allNotifications];
          break;
        case 1: // Unread - seulement non lues
          _filteredNotifications =
              _allNotifications
                  .where((notification) => !notification['isRead'])
                  .toList();
          break;
        case 2: // Read - seulement lues
          _filteredNotifications =
              _allNotifications
                  .where((notification) => notification['isRead'])
                  .toList();
          break;
      }
    });
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
    setState(() {
      // 1. Trouver la notification dans la liste complète
      final originalIndex = _findNotificationIndexById(
        notificationToMark['id'],
      );

      if (originalIndex != -1) {
        // 2. Marquer comme lue dans la liste principale
        _allNotifications[originalIndex]['isRead'] = true;

        // 3. Mettre à jour les listes filtrées selon l'onglet actif
        if (_tabController.index == 0) {
          // Onglet "All" - mettre à jour le statut sans retirer
          final allIndex = _filteredNotifications.indexWhere(
            (n) => n['id'] == notificationToMark['id'],
          );
          if (allIndex != -1) {
            _filteredNotifications[allIndex]['isRead'] = true;
          }
        } else if (_tabController.index == 1) {
          // Onglet "Unread" - retirer la notification
          _filteredNotifications.removeWhere(
            (n) => n['id'] == notificationToMark['id'],
          );
        } else if (_tabController.index == 2) {
          // Onglet "Read" - ajouter la notification si elle n'y est pas
          final existsInRead = _filteredNotifications.any(
            (n) => n['id'] == notificationToMark['id'],
          );
          if (!existsInRead) {
            _filteredNotifications.insert(0, _allNotifications[originalIndex]);
          }
        }

        // 4. Forcer le rafraîchissement des autres onglets si nécessaire
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _handleTabSelection();
          }
        });
      }
    });
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
                        fontSize: 13,
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
        'Send Notification',
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher les destinataires sélectionnés
            Text(
              'Recipients: ${_selectedUsers.isEmpty ? "All Users" : "${_selectedUsers.length} Selected Users"}',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _broadcastTitleController,
              style: GoogleFonts.montserrat(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.montserrat(color: Colors.white70),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: const Color(0xFF2A3B4E),
                hintText: 'Enter notification title',
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
                hintText: 'Enter notification content',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showBroadcastDialog = false;
              _selectedUsers =
                  []; // Réinitialiser les utilisateurs sélectionnés
            });
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _showBroadcastDialog = false;
              _showUserSelectionDialog = true;
            });
          },
          child: Text(
            'Back to Recipients',
            style: GoogleFonts.montserrat(color: Colors.blueAccent),
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
                      : const BorderSide(
                        color: Colors.grey,
                        width: 0.5,
                      ), // Subtle border for read
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
                    notification['title'].replaceFirst('New Message From ', ''),
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
    _markAsRead(notification);
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
      resizeToAvoidBottomInset: true, // Add this line
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
                _broadcastTitleController.clear();
                _broadcastMessageController.clear();
                _selectedUsers = [];
                _selectAllUsers = false;
                _showUserSelectionDialog =
                    true; // Ouvrir d'abord le dialogue de sélection d'utilisateurs
                _showMessaging = false;
                _showBroadcastDialog = false;
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

          // User Selection Dialog (nouvel élément)
          if (_showUserSelectionDialog)
            Center(child: _buildUserSelectionDialog()),

          // Broadcast Dialog
          if (_showBroadcastDialog) Center(child: _buildBroadcastDialog()),
        ],
      ),
    );
  }
}
