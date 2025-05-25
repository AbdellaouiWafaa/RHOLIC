import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Modèles de données
class Admin {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;
  final String role;
  final DateTime createdAt;
  bool isBlocked;

  Admin({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.role,
    required this.createdAt,
    this.isBlocked = false,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phone;
  final DateTime memberSince;
  bool isBlocked;
  final List<BookLoan> loans;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.memberSince,
    this.isBlocked = false,
    this.loans = const [],
  });
}

class BookLoan {
  final String bookTitle;
  final String bookAuthor;
  final DateTime borrowDate;
  final DateTime dueDate;
  final bool isReturned;
  final DateTime? returnDate;

  BookLoan({
    required this.bookTitle,
    required this.bookAuthor,
    required this.borrowDate,
    required this.dueDate,
    this.isReturned = false,
    this.returnDate,
  });

  bool get isOverdue => !isReturned && DateTime.now().isAfter(dueDate);
}

class ManageMainScreen extends StatefulWidget {
  const ManageMainScreen({super.key});

  @override
  State<ManageMainScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageMainScreen> {
  void addUserDynamically(User newUser) {
    setState(() {
      users.add(newUser);
    });
  }

  // Listes pour stocker les admins et users
  List<Admin> admins = [
    Admin(
      id: '1',
      name: 'Jane Doe',
      email: 'jane@library.com',
      address: '456 Elm St',
      phone: '+0987654321',
      role: 'Super Admin',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Admin(
      id: '2',
      name: 'John Smith',
      email: 'john@library.com',
      address: '123 Main St',
      phone: '+1234567890',
      role: 'Admin',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      isBlocked: true,
    ),
  ];

  List<User> users = [
    User(
      id: '1',
      name: 'Alice Johnson',
      email: 'alice@email.com',
      address: '123 London',
      phone: '+1234567890',
      memberSince: DateTime.now().subtract(const Duration(days: 60)),
      loans: [
        BookLoan(
          bookTitle: 'Alice in Wonderland',
          bookAuthor: 'Lewis Carroll',
          borrowDate: DateTime.now().subtract(const Duration(days: 10)),
          dueDate: DateTime.now().add(const Duration(days: 4)),
        ),
        BookLoan(
          bookTitle: 'Dracula',
          bookAuthor: 'Bram Stoker',
          borrowDate: DateTime.now().subtract(const Duration(days: 20)),
          dueDate: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ],
    ),
    User(
      id: '2',
      name: 'Bob Wilson',
      email: 'bob@email.com',
      address: '789 London',
      phone: '+1987654321',
      memberSince: DateTime.now().subtract(const Duration(days: 90)),
      isBlocked: true,
      loans: [
        BookLoan(
          bookTitle: 'Frankenstein',
          bookAuthor: 'Mary Shelley',
          borrowDate: DateTime.now().subtract(const Duration(days: 25)),
          dueDate: DateTime.now().subtract(const Duration(days: 11)),
        ),
      ],
    ),
    User(
      id: '3',
      name: 'Emma Brown',
      email: 'emma@email.com',
      address: '321 London',
      phone: '+1122334455',
      memberSince: DateTime.now().subtract(const Duration(days: 120)),
      loans: [],
    ),
  ];

  // Controllers pour les formulaires
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController adminEmailController = TextEditingController();
  final TextEditingController adminAddressController = TextEditingController();
  final TextEditingController adminPhoneController = TextEditingController();
  final TextEditingController adminRoleController = TextEditingController();

  @override
  void dispose() {
    adminNameController.dispose();
    adminEmailController.dispose();
    adminAddressController.dispose();
    adminPhoneController.dispose();
    adminRoleController.dispose();
    super.dispose();
  }

  // Styles réutilisables
  TextStyle get sectionTitleStyle => GoogleFonts.montserrat(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  TextStyle get cardTitleStyle => GoogleFonts.montserrat(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  TextStyle get bodyTextStyle => GoogleFonts.montserrat(
    fontSize: 14,
    color: Colors.white.withOpacity(0.8),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Admin Management
            Text('Admin Management', style: sectionTitleStyle),
            const SizedBox(height: 16),
            _buildAdminSection(),
            const SizedBox(height: 30),

            // Section User Management
            Text('User Management', style: sectionTitleStyle),
            const SizedBox(height: 16),
            _buildUserSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminSection() {
    return Column(
      children: [
        _buildManageCard(
          title: 'Add New Admin',
          subtitle: 'Create a new administrator account',
          icon: Icons.person_add,
          onTap: _showAddAdminDialog,
        ),
        _buildManageCard(
          title: 'Existing Admins',
          subtitle: 'View and manage existing admins',
          icon: Icons.person,
          onTap: _showExistingAdminsDialog,
        ),
        _buildManageCard(
          title: 'Block Admin',
          subtitle: 'Temporarily block an admin',
          icon: Icons.person_remove,
          onTap: _showBlockAdminDialog,
        ),
        _buildManageCard(
          title: 'Unblock Admin',
          subtitle: 'Unblock a previously blocked admin',
          icon: Icons.person,
          onTap: _showUnblockAdminDialog,
        ),
      ],
    );
  }

  Widget _buildUserSection() {
    return Column(
      children: [
        _buildManageCard(
          title: 'Add New User',
          subtitle: 'Create a new administrator account',
          icon: Icons.person_outline,
          onTap: _showAddUserDialog,
        ),
        _buildManageCard(
          title: 'Existing Users',
          subtitle: 'View and manage all users',
          icon: Icons.person_outline,
          onTap: _showExistingUsersDialog,
        ),
        _buildManageCard(
          title: 'Block User',
          subtitle: 'Temporarily block a user',
          icon: Icons.person_add_alt_1,
          onTap: _showBlockUserDialog,
        ),
        _buildManageCard(
          title: 'Unblock User',
          subtitle: 'Unblock a previously blocked user',
          icon: Icons.person_outline,
          onTap: _showUnblockUserDialog,
        ),
      ],
    );
  }

  void _showAddUserDialog() {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController userEmailController = TextEditingController();
    final TextEditingController userAddressController = TextEditingController();
    final TextEditingController userPhoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text('Add New User', style: cardTitleStyle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userNameController,
                style: bodyTextStyle,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userEmailController,
                style: bodyTextStyle,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userAddressController,
                style: bodyTextStyle,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userPhoneController,
                style: bodyTextStyle,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: bodyTextStyle,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: bodyTextStyle),
          ),
          ElevatedButton(
            onPressed: () {
              if (userNameController.text.isNotEmpty &&
                  userEmailController.text.isNotEmpty &&
                  userAddressController.text.isNotEmpty &&
                  userPhoneController.text.isNotEmpty) {
                setState(() {
                  users.add(
                    User(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: userNameController.text,
                      email: userEmailController.text,
                      address: userAddressController.text,
                      phone: userPhoneController.text,
                      memberSince: DateTime.now(),
                    ),
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User added successfully!'),
                  ),
                );
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  Widget _buildManageCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1E2A3B),
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.white24,
        onTap: onTap,
        child: SizedBox(
          height: 120, // Hauteur plus grande ici
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3B4D),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 40, // icône plus grande
                    color: const Color(0xFFB19E44),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // texte centré verticalement
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.montserrat(
                          fontSize: 22, // titre plus grand
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          fontSize: 16, // sous-titre plus grand
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20, // flèche plus grande
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // (Toutes tes méthodes de dialogue et autres sont identiques à ton code d'origine, je les intègre ici sans changement)

  void _showAddAdminDialog() {
    adminNameController.clear();
    adminEmailController.clear();
    adminAddressController.clear();
    adminPhoneController.clear();
    adminRoleController.clear();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Add New Admin', style: cardTitleStyle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: adminNameController,
                    style: bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: bodyTextStyle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: adminEmailController,
                    style: bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: bodyTextStyle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: adminAddressController,
                    style: bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: bodyTextStyle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: adminPhoneController,
                    style: bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: bodyTextStyle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: adminRoleController,
                    style: bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: bodyTextStyle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: bodyTextStyle),
              ),
              ElevatedButton(
                onPressed: () {
                  if (adminNameController.text.isNotEmpty &&
                      adminEmailController.text.isNotEmpty &&
                      adminRoleController.text.isNotEmpty &&
                      adminAddressController.text.isNotEmpty &&
                      adminRoleController.text.isNotEmpty) {
                    setState(() {
                      admins.add(
                        Admin(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: adminNameController.text,
                          email: adminEmailController.text,
                          address: adminAddressController.text,
                          phone: adminPhoneController.text,
                          role: adminRoleController.text,
                          createdAt: DateTime.now(),
                        ),
                      );
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Admin added successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Add Admin'),
              ),
            ],
          ),
    );
  }

  void _showExistingAdminsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Existing Admins', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.builder(
                itemCount: admins.length,
                itemBuilder: (context, index) {
                  final admin = admins[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _showAdminDetails(admin),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF121921),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                admin.isBlocked
                                    ? Colors.red
                                    : const Color(0xFFB19E44),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                admin.isBlocked
                                    ? Colors.red
                                    : const Color(0xFFB19E44),
                            child: Text(
                              admin.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(admin.name, style: cardTitleStyle),
                                const SizedBox(height: 4),
                                Text(admin.email, style: bodyTextStyle),
                              ],
                            ),
                          ),
                          Icon(
                            admin.isBlocked ? Icons.block : Icons.check_circle,
                            color: admin.isBlocked ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }

  void _showAdminDetails(Admin admin) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Admin Details', style: cardTitleStyle),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          admin.isBlocked
                              ? Colors.red
                              : const Color(0xFFB19E44),
                      child: Text(
                        admin.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow('Full Name:', admin.name),
                  _buildDetailRow('Email:', admin.email),
                  _buildDetailRow('Phone:', admin.phone),
                  _buildDetailRow('Address:', admin.address),
                  _buildDetailRow('Role:', admin.role),
                  _buildDetailRow(
                    'Status:',
                    admin.isBlocked ? 'Blocked' : 'Active',
                    valueColor: admin.isBlocked ? Colors.red : Colors.green,
                  ),
                  _buildDetailRow(
                    'Member Since:',
                    '${admin.createdAt.day}/${admin.createdAt.month}/${admin.createdAt.year}',
                  ),
                  _buildDetailRow('Admin ID:', admin.id),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: bodyTextStyle),
              ),
              if (!admin.isBlocked)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      admin.isBlocked = true;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${admin.name} has been blocked')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Block Admin'),
                ),
              if (admin.isBlocked)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      admin.isBlocked = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${admin.name} has been unblocked'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Unblock Admin'),
                ),
            ],
          ),
    );
  }

  void _showBlockAdminDialog() {
    final activeAdmins = admins.where((admin) => !admin.isBlocked).toList();

    if (activeAdmins.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active admins to block')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Block Admin', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: activeAdmins.length,
                itemBuilder: (context, index) {
                  final admin = activeAdmins[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFB19E44),
                      child: Text(admin.name[0].toUpperCase()),
                    ),
                    title: Text(admin.name, style: cardTitleStyle),
                    subtitle: Text(admin.email, style: bodyTextStyle),
                    onTap: () {
                      // Nouveau code pour la boîte de dialogue de confirmation
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E2A3B),
                              title: Text(
                                'Confirm Block Admin',
                                style: cardTitleStyle,
                              ),
                              content: Text(
                                'Are you sure you want to block ${admin.name}?',
                                style: bodyTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: bodyTextStyle),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      admin.isBlocked = true;
                                    });
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de confirmation
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de sélection d'admin
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${admin.name} has been blocked',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      122,
                                      29,
                                      22,
                                    ),
                                  ),
                                  child: const Text('Block'),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }

  void _showUnblockAdminDialog() {
    final blockedAdmins = admins.where((admin) => admin.isBlocked).toList();

    if (blockedAdmins.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No blocked admins to unblock')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Unblock Admin', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: blockedAdmins.length,
                itemBuilder: (context, index) {
                  final admin = blockedAdmins[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Text(admin.name[0].toUpperCase()),
                    ),
                    title: Text(admin.name, style: cardTitleStyle),
                    subtitle: Text(admin.email, style: bodyTextStyle),
                    onTap: () {
                      // Nouveau code pour le dialogue de confirmation de déblocage
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E2A3B),
                              title: Text(
                                'Confirm Unblock Admin',
                                style: cardTitleStyle,
                              ),
                              content: Text(
                                'Are you sure you want to unblock ${admin.name}?',
                                style: bodyTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: bodyTextStyle),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      admin.isBlocked = false;
                                    });
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de confirmation
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de sélection d'admin
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${admin.name} has been unblocked',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      32,
                                      139,
                                      35,
                                    ),
                                  ),
                                  child: const Text('Unblock'),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }

  // Dialogs pour User Management
  void _showExistingUsersDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Existing Users', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 500,
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      onPressed: () => _showUserDetails(user),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF121921),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                user.isBlocked
                                    ? Colors.red
                                    : const Color(0xFFB19E44),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                user.isBlocked
                                    ? Colors.red
                                    : const Color(0xFFB19E44),
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name, style: cardTitleStyle),
                                const SizedBox(height: 4),
                                Text(user.email, style: bodyTextStyle),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                user.isBlocked
                                    ? Icons.block
                                    : Icons.check_circle,
                                color:
                                    user.isBlocked ? Colors.red : Colors.green,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${user.loans.where((loan) => !loan.isReturned).length} loans',
                                style: bodyTextStyle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('User Details', style: cardTitleStyle),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          user.isBlocked ? Colors.red : const Color(0xFFB19E44),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Personal Information',
                    style: cardTitleStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow('Full Name:', user.name),
                  _buildDetailRow('Email:', user.email),
                  _buildDetailRow('Address:', user.address),
                  _buildDetailRow('Phone:', user.phone),
                  _buildDetailRow(
                    'Status:',
                    user.isBlocked ? 'Blocked' : 'Active',
                    valueColor: user.isBlocked ? Colors.red : Colors.green,
                  ),
                  _buildDetailRow(
                    'Member Since:',
                    '${user.memberSince.day}/${user.memberSince.month}/${user.memberSince.year}',
                  ),
                  _buildDetailRow('User ID:', user.id),
                  const SizedBox(height: 24),
                  Text(
                    'Loan Information',
                    style: cardTitleStyle.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (user.loans.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No loan history',
                          style: bodyTextStyle.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    _buildDetailRow(
                      'Total Loans:',
                      user.loans.length.toString(),
                    ),
                    _buildDetailRow(
                      'Active Loans:',
                      user.loans
                          .where((loan) => !loan.isReturned)
                          .length
                          .toString(),
                    ),
                    _buildDetailRow(
                      'Overdue Books:',
                      user.loans
                          .where((loan) => loan.isOverdue)
                          .length
                          .toString(),
                      valueColor:
                          user.loans.any((loan) => loan.isOverdue)
                              ? Colors.red
                              : Colors.green,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Book Details:',
                      style: bodyTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...user.loans
                        .map(
                          (loan) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFF121921),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    loan.isOverdue
                                        ? Colors.red
                                        : loan.isReturned
                                        ? Colors.green
                                        : const Color(0xFFB19E44),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      loan.isReturned
                                          ? Icons.check_circle
                                          : loan.isOverdue
                                          ? Icons.warning
                                          : Icons.book,
                                      color:
                                          loan.isReturned
                                              ? Colors.green
                                              : loan.isOverdue
                                              ? Colors.red
                                              : const Color(0xFFB19E44),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        loan.bookTitle,
                                        style: bodyTextStyle.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Author: ${loan.bookAuthor}',
                                  style: bodyTextStyle,
                                ),
                                Text(
                                  'Due: ${loan.dueDate.day}/${loan.dueDate.month}/${loan.dueDate.year}',
                                  style: bodyTextStyle.copyWith(
                                    color: loan.isOverdue ? Colors.red : null,
                                  ),
                                ),
                                if (loan.isReturned && loan.returnDate != null)
                                  Text(
                                    'Returned: ${loan.returnDate!.day}/${loan.returnDate!.month}/${loan.returnDate!.year}',
                                    style: bodyTextStyle.copyWith(
                                      color: Colors.green,
                                    ),
                                  ),
                                if (loan.isOverdue)
                                  Text(
                                    'OVERDUE',
                                    style: bodyTextStyle.copyWith(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                        ,
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close', style: bodyTextStyle),
              ),
              if (!user.isBlocked)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      user.isBlocked = true;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${user.name} has been blocked')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Block User'),
                ),
              if (user.isBlocked)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      user.isBlocked = false;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${user.name} has been unblocked'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Unblock User'),
                ),
            ],
          ),
    );
  }

  // Helper method pour construire les lignes de détails
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: bodyTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: bodyTextStyle.copyWith(
                color: valueColor ?? bodyTextStyle.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog() {
    final activeUsers = users.where((user) => !user.isBlocked).toList();

    if (activeUsers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No active users to block')));
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Block User', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: activeUsers.length,
                itemBuilder: (context, index) {
                  final user = activeUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFB19E44),
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name, style: cardTitleStyle),
                    subtitle: Text(user.email, style: bodyTextStyle),
                    onTap: () {
                      // Nouveau code pour la boîte de dialogue de confirmation
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E2A3B),
                              title: Text(
                                'Confirm Block User',
                                style: cardTitleStyle,
                              ),
                              content: Text(
                                'Are you sure you want to block ${user.name}?',
                                style: bodyTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: bodyTextStyle),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      user.isBlocked = true;
                                    });
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de confirmation
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de sélection d'admin
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${user.name} has been blocked',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      122,
                                      29,
                                      22,
                                    ),
                                  ),
                                  child: const Text('Block'),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }

  void _showUnblockUserDialog() {
    final blockedUsers = users.where((user) => user.isBlocked).toList();

    if (blockedUsers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No blocked users to unblock')),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B),
            title: Text('Unblock User', style: cardTitleStyle),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: blockedUsers.length,
                itemBuilder: (context, index) {
                  final admin = blockedUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 144, 37, 30),
                      child: Text(admin.name[0].toUpperCase()),
                    ),
                    title: Text(admin.name, style: cardTitleStyle),
                    subtitle: Text(admin.email, style: bodyTextStyle),
                    onTap: () {
                      // Nouveau code pour le dialogue de confirmation de déblocage
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E2A3B),
                              title: Text(
                                'Confirm Unblock User',
                                style: cardTitleStyle,
                              ),
                              content: Text(
                                'Are you sure you want to unblock ${admin.name}?',
                                style: bodyTextStyle,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel', style: bodyTextStyle),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      admin.isBlocked = false;
                                    });
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de confirmation
                                    Navigator.pop(
                                      context,
                                    ); // Fermer le dialogue de sélection d'admin
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${admin.name} has been unblocked',
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      32,
                                      139,
                                      35,
                                    ),
                                  ),
                                  child: const Text('Unblock'),
                                ),
                              ],
                            ),
                      );
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: bodyTextStyle),
              ),
            ],
          ),
    );
  }
}
