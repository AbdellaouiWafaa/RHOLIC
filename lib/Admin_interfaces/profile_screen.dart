import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the image_picker package (add to your pubspec.yaml)
// import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For File class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Données fictives pour l'exemple
  String userName = "Jane Doe";
  String userRole = "Administrator";
  String email = "jane.doe@gmail.com";
  String phone = "+213 5 12 99 **";
  String joinDate = "15/03/2022";
  String address = "123 Library Street, Algiers";

  // Simulate profile image path (can be asset or a file path if using image_picker)
  String _profileImagePath = 'assets/images/admin.png'; // Initial image

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
          crossAxisAlignment: CrossAxisAlignment.center, // Keep column centered for the rest of the content
          children: [
             // Added the "Profile" title here, styled like section headers
            Padding(
               padding: const EdgeInsets.only(top: 18.0, bottom: 16.0), // Add padding around the title
               child: Align( // Use Align to position the text within the padding
                 alignment: Alignment.center, // Align text to the left
                 child: Text(
                   'Profile',
                   style: GoogleFonts.montserrat( // Use the same style as section titles
                     fontSize: 30, // Increased font size
                     fontWeight: FontWeight.w600,
                     color: Colors.white.withOpacity(0.7), // Color from section titles
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

            // Removed Change Password action tile as requested
            // _buildActionTile(
            //   Icons.lock_outline,
            //   "Change Password",
            //   "Update your security credentials",
            //   () {
            //     _showChangePasswordDialog();
            //   },
            // ),

            _buildActionTile(
              Icons.settings_outlined,
              "Preferences",
              "Manage app settings and notifications",
              () {
                _showPreferencesDialog();
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
          Expanded( // Use Expanded to prevent overflow of long text
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
                  overflow: TextOverflow.ellipsis, // Add ellipsis if still overflows
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
        content: StatefulBuilder( // Use StatefulBuilder to update dialog UI
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
                           tempProfileImagePath = tempProfileImagePath.startsWith('assets/')
                               ? 'assets/images/dummy_profile.png' // Assume you have a dummy_profile.png
                               : 'assets/images/admin.png';
                         });
                         // --- End Simulation ---
                      },
                      child: CircleAvatar(
                        radius: 50,
                         // Use FileImage if tempProfileImagePath is a file path, else AssetImage
                        backgroundImage: tempProfileImagePath.startsWith('assets/')
                            ? AssetImage(tempProfileImagePath) as ImageProvider<Object>
                            : FileImage(File(tempProfileImagePath)) as ImageProvider<Object>,
                        backgroundColor: Colors.grey,
                         child: const Icon( // Add a camera icon overlay
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
                 _profileImagePath = tempProfileImagePath; // Update the main profile image
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

  // Removed the Change Password dialog function as requested
  // void _showChangePasswordDialog() { ... }

  // Interface pour les préférences
  void _showPreferencesDialog() {
    bool enableNotifications = true; // Example initial value
    bool darkMode = true; // Example initial value
    String language = 'English'; // Example initial value

    final languages = ['English', 'Français', 'العربية'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to update dialog UI
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E2A3B),
              title: Text(
                'Preferences',
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
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        'Notifications',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Switch(
                        value: enableNotifications,
                        onChanged: (value) {
                          setState(() {
                            enableNotifications = value;
                          });
                           // In a real app, save this preference
                        },
                        activeColor: const Color(0xFFB19E44),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Dark Mode',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Switch(
                        value: darkMode,
                        onChanged: (value) {
                          setState(() {
                            darkMode = value;
                          });
                           // In a real app, apply this theme preference
                        },
                        activeColor: const Color(0xFFB19E44),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                          child: Text(
                            'Language',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF121921),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: const Color(0xFF1E2A3B),
                              value: language,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFFB19E44),
                              ),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    language = newValue;
                                  });
                                   // In a real app, apply this language preference
                                  // ScaffoldMessenger.of(context).showSnackBar( // Show feedback
                                  //   SnackBar(content: Text('Language set to $newValue')),
                                  // );
                                }
                              },
                              items: languages.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
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
                    // In a real app, save preferences here
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Preferences saved successfully!',
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
                    'Save',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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