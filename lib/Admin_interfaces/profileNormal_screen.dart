import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the image_picker package (add to your pubspec.yaml)
// import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File class

class ProfileNormalScreen extends StatefulWidget {
  const ProfileNormalScreen({Key? key}) : super(key: key);

  @override
  State<ProfileNormalScreen> createState() => _ProfileNormalScreenState();
}

class _ProfileNormalScreenState extends State<ProfileNormalScreen> {
  // Données fictives pour l'exemple
  String userName = "Amey Stone";
  String userRole = "Administrator";
  String email = "ahlemboudaoud7@gmail.com";
  String phone = "0559620001";
  String joinDate = "28/03/2022";
  String address = "Tlemcen";

  // Simulate profile image path (can be asset or a file path if using image_picker)
  String _profileImagePath = 'assets/images/admin2.png'; // Initial image

  // Uncomment if using image_picker
  // final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      // Removed the entire AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Keep column centered for the rest of the content
          children: [
            // Added the "Profile" title here, styled like section headers
            Padding(
              padding: const EdgeInsets.only(
                  top: 18.0, bottom: 16.0), // Add padding around the title
              child: Align(
                // Use Align to position the text within the padding
                alignment: Alignment.center, // Align text to the left
                child: Text(
                  'Profile',
                  style: GoogleFonts.montserrat(
                    // Use the same style as section titles
                    fontSize: 30, // Increased font size
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(179, 255, 255, 255), // Converted from withOpacity(0.7)
                  ),
                ),
              ),
            ),

            // Removed the initial SizedBox(height: 20)

            // Photo de profil
            CircleAvatar(
              radius: 60,
              // Use FileImage if _profileImagePath is a file path, else AssetImage
              backgroundImage: _profileImagePath.startsWith('assets/')
                  ? AssetImage(_profileImagePath) as ImageProvider<Object>
                  : FileImage(File(_profileImagePath)) as ImageProvider<Object>,
              backgroundColor: Colors.grey,
            ),

            const SizedBox(height: 20),

            // Nom d'utilisateur
            Text(
              userName,
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Rôle de l'utilisateur
            Text(
              userRole,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: const Color(0xFFB19E44),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 40),

            // Informations personnelles
            _buildInfoSection(context, "Personal Information"),

            _buildInfoTile(
              Icons.email_outlined,
              "Email",
              email,
            ),

            _buildInfoTile(
              Icons.phone_outlined,
              "Phone",
              phone,
            ),

            _buildInfoTile(
              Icons.location_on_outlined,
              "Address",
              address,
            ),

            _buildInfoTile(
              Icons.calendar_today_outlined,
              "Join Date",
              joinDate,
            ),

            const SizedBox(height: 30),

            // Section actions
            _buildInfoSection(context, "Actions"),

            _buildActionTile(
              Icons.edit_outlined,
              "Edit Profile",
              "Update your personal information",
              () {
                _showEditProfileDialog();
              },
            ),

             _buildActionTile(
               Icons.lock_outline,
               "Change Password",
               "Update your security credentials",
               () {
                 _showChangePasswordDialog();
               },
             ),
             
            _buildActionTile(
              Icons.logout,
              "Logout",
              "Sign out from your account",
              () {
                _showLogoutDialog();
              },
              isLogout: true,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF1E2A3B),
            width: 2.0,
          ),
        ),
      ),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFFB19E44),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            // Use Expanded to prevent overflow of long text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 2, // Allow text to wrap
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if still overflows
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isLogout = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: const Color(0xFF1E2A3B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        leading: Icon(
          icon,
          color: isLogout ? Colors.redAccent : const Color(0xFFB19E44),
          size: 28,
        ),
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isLogout ? Colors.redAccent : Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }

  // Interface pour modifier le profil
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: userName);
    final emailController = TextEditingController(text: email);
    final phoneController = TextEditingController(text: phone);
    final addressController = TextEditingController(text: address);

    // Simulate a temporary profile image path for the dialog preview
    String tempProfileImagePath = _profileImagePath;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: StatefulBuilder(
          // Use StatefulBuilder to update dialog UI
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    // Profile photo with edit option
                    GestureDetector(
                      onTap: () async {
                        // Simulate picking a new image
                        // In a real app, you would use image_picker here:
                        // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                        // if (pickedFile != null) {
                        //   setState(() {
                        //     tempProfileImagePath = pickedFile.path;
                        //   });
                        // }

                        // --- Simulation ---
                        // Toggle between two dummy images for demo
                        setState(() {
                          tempProfileImagePath = tempProfileImagePath
                                  .startsWith('assets/')
                              ? 'assets/images/dummy_profile.png' // Assume you have a dummy_profile.png
                              : 'assets/images/admin2.png';
                        });
                        // --- End Simulation ---
                      },
                      child: CircleAvatar(
                        radius: 50,
                        // Use FileImage if tempProfileImagePath is a file path, else AssetImage
                        backgroundImage:
                            tempProfileImagePath.startsWith('assets/')
                                ? AssetImage(tempProfileImagePath)
                                    as ImageProvider<Object>
                                : FileImage(File(tempProfileImagePath))
                                    as ImageProvider<Object>,
                        backgroundColor: Colors.grey,
                        child: const Icon(
                          // Add a camera icon overlay
                          Icons.camera_alt,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildEditField(
                      controller: nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildEditField(
                      controller: addressController,
                      label: 'Address',
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB19E44),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                userName = nameController.text;
                email = emailController.text;
                phone = phoneController.text;
                address = addressController.text;
                _profileImagePath =
                    tempProfileImagePath; // Update the main profile image
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profile updated successfully!',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Save Changes',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog for changing password
 // Dans la méthode _showChangePasswordDialog, ajoutez le texte "Forgot your password?"
void _showChangePasswordDialog() {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1E2A3B),
      title: Text(
        'Change Password',
        style: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEditField(
              controller: currentPasswordController,
              label: 'Current Password',
              icon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(height: 8),
            // Ajout du lien "Forgot your password?"
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Ferme le dialogue actuel
                  _showForgotPasswordDialog(); // Ouvre le nouveau dialogue
                },
                child: Text(
                  'Forgot your password?',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: const Color(0xFFB19E44),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildEditField(
              controller: newPasswordController,
              label: 'New Password',
              icon: Icons.lock_open_outlined,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            _buildEditField(
              controller: confirmPasswordController,
              label: 'Confirm New Password',
              icon: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        // ... (le reste du code reste inchangé)
      ],
    ),
  );
}

// Ajoutez cette nouvelle méthode pour afficher le dialogue de récupération
void _showForgotPasswordDialog() {
  final emailController = TextEditingController(text: email);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1E2A3B),
      title: Text(
        'Password Recovery',
        style: GoogleFonts.montserrat(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email to receive a recovery code',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            _buildEditField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            Text(
              'We will send you a code to recover your account',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB19E44),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: () {
            // Ici vous devriez implémenter la logique d'envoi du code
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Recovery code sent to ${emailController.text}',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Text(
            'Send Code',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
  );
}
  // Interface pour la déconnexion
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2A3B),
        title: Text(
          'Logout',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Simulate logout by navigating back (like the back arrow)
              Navigator.pop(context); // Go back to the previous screen
              // If this was the root screen, you might use SystemNavigator.pop()
              // or navigate to a dedicated login screen.
              // Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false); // Example if you have a login route
            },
            child: Text(
              'Logout',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour les champs d'édition
  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label déplacé au-dessus du champ
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 6.0),
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            // Suppression du labelText puisqu'il est maintenant au-dessus
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFB19E44),
            ),
            filled: true,
            fillColor: const Color(0xFF121921),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
