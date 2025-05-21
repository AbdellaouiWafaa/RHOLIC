import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageScreen extends StatelessWidget {
  ManageScreen({super.key});

  // Styles pour Welcome section (basique comme dans DashboardContent) - Déjà présents dans votre code fourni
  final TextStyle welcomeBackStyle = GoogleFonts.islandMoments(
    fontSize: 32,
    color: Colors.white,
  );

  final TextStyle adminNameStyle = GoogleFonts.islandMoments(
    fontStyle: FontStyle.italic,
    fontSize: 42,
    color: Colors.white70,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Aligner les éléments à gauche
          children: [
            // Section de bienvenue avec photo de profil (Centrée comme dans DashboardScreen) - Structure déjà corrigée dans votre code fourni
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ), // Padding comme dans Dashboard
                child: Row(
                  mainAxisSize:
                      MainAxisSize
                          .min, // Adapter la taille de la Row à son contenu
                  children: [
                    const CircleAvatar(
                      radius: 36, // Taille comme dans Dashboard
                      backgroundImage: AssetImage(
                        'assets/images/admin.png',
                      ), // Assurez-vous que l'image existe
                      backgroundColor: Colors.grey, // Couleur de fallback
                      // Si vous voulez une correspondance exacte avec DashboardContent, vous pouvez retirer le child: Text('A', ...)
                      // child: Text('A', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 20,
                    ), // Espacement comme dans Dashboard
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Utilise les styles que vous avez définis ci-dessus - Déjà correct dans votre code fourni
                        Text('Welcome Back,', style: welcomeBackStyle),
                        Text('Jane', style: adminNameStyle),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Espacement après l'en-tête - Déjà correct dans votre code fourni
            const SizedBox(height: 20),

            // Container principal avec les options de gestion
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ), // Marges latérales
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2A3B),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre principal (inchangé)
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: const Color(0xFFB19E44),
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Manage Accounts',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Cartes d'action pour les administrateurs
                  _buildManageCard(
                    context,
                    'Add New Admin',
                    'Create a new administrator account',
                    Icons.person_add,
                    () => _navigateToForm(
                      context,
                      FormType.addAdmin,
                    ), // Utilise FormType défini ci-dessous
                  ),
                  _buildManageCard(
                    context,
                    'Update Admin',
                    'Modify an existing administrator account',
                    Icons.person,
                    () => _navigateToForm(
                      context,
                      FormType.updateAdmin,
                    ), // Utilise FormType défini ci-dessous
                  ),
                  _buildManageCard(
                    context,
                    'Delete Admin',
                    'Remove an administrator account',
                    Icons.person_remove,
                    () => _navigateToForm(
                      context,
                      FormType.deleteAdmin,
                    ), // Utilise FormType défini ci-dessous
                  ),

                  const SizedBox(
                    height: 30,
                  ), // Espacement entre les sections Admins et Members
                  // Cartes d'action pour les membres
                  _buildManageCard(
                    context,
                    'Add New Member',
                    'Create a new member account',
                    Icons.person_add_alt_1,
                    () => _navigateToForm(
                      context,
                      FormType.addUser,
                    ), // Utilise FormType défini ci-dessous
                  ),
                  _buildManageCard(
                    context,
                    'Update Member',
                    'Modify an existing member account',
                    Icons.person_outline,
                    () => _navigateToForm(
                      context,
                      FormType.updateUser,
                    ), // Utilise FormType défini ci-dessous
                  ),
                  _buildManageCard(
                    context,
                    'Delete Member',
                    'Remove a member account',
                    Icons.person_remove_alt_1,
                    () => _navigateToForm(
                      context,
                      FormType.deleteUser,
                    ), // Utilise FormType défini ci-dessous
                  ),
                ],
              ),
            ),

            // Bouton de sauvegarde (inchangé) - J'ajoute un Center ici aussi pour être cohérent
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Center(
                // Centrer le bouton
                child: ElevatedButton(
                  onPressed: () {
                    // MODIFICATION: Utilisation de SnackBar stylisé
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Changes saved successfully!',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: const Color(0xFFB19E44),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2A3B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Save Changes',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer les cartes d'action (inchangée)
  Widget _buildManageCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0), // Marge entre les cartes
      color: const Color(0xFF1E2A3B), // Couleur de fond de la carte
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Coins arrondis
        // Bordure retirée
      ),
      elevation: 6.0, // Élévation pour l'ombre
      child: InkWell(
        onTap: onTap, // L'action au clic
        borderRadius: BorderRadius.circular(
          12.0,
        ), // Assurer le ripple effect respecte les coins arrondis
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ), // Padding interne
          child: Row(
            children: [
              // Conteneur stylisé pour l'icône (inchangé)
              Container(
                padding: const EdgeInsets.all(8.0), // Espace autour de l'icône
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF2C3B4D,
                  ), // Couleur de fond légère pour l'icône
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ), // Coins arrondis pour le fond de l'icône
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFFB19E44), // Couleur de l'icône
                  size: 28, // Taille de l'icône
                ),
              ),
              const SizedBox(
                width: 16,
              ), // Espacement entre l'icône et le texte/sous-titre
              Expanded(
                // Permet à la colonne de texte de prendre l'espace restant
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ), // Espacement entre le titre et le sous-titre
                    Text(
                      subtitle,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ), // Espacement entre le texte et la flèche
              const Icon(
                Icons.arrow_forward_ios, // Icône de flèche
                color: Colors.white70,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour naviguer vers le formulaire approprié (inchangée)
  void _navigateToForm(BuildContext context, FormType type) {
    String title;
    String buttonText;

    switch (type) {
      case FormType.addAdmin:
        title = 'Add New Admin';
        buttonText = 'Save Information';
        break;
      case FormType.updateAdmin:
        title = 'Update an Admin';
        buttonText = 'Save Changes';
        break;
      case FormType.deleteAdmin:
        title = 'Delete an Admin';
        buttonText = 'Delete Admin';
        break;
      case FormType.addUser:
        title = 'Add New User';
        buttonText = 'Save Information';
        break;
      case FormType.updateUser:
        title = 'Update a User';
        buttonText = 'Save Changes';
        break;
      case FormType.deleteUser:
        title = 'Delete a User';
        buttonText = 'Delete User';
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => UserForm(
              // Utilise UserForm défini ci-dessous
              formType: type,
              title: title,
              buttonText: buttonText,
            ),
      ),
    );
  }
}

enum FormType {
  addAdmin,
  updateAdmin,
  deleteAdmin,
  addUser,
  updateUser,
  deleteUser,
}

class UserForm extends StatefulWidget {
  final FormType formType;
  final String title;
  final String buttonText;

  const UserForm({
    super.key,
    required this.formType,
    required this.title,
    required this.buttonText,
  });

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLibraryAdmin = false;
  bool _isLibraryAssistant = false;
  bool _isLibraryStaff = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Pré-remplir les champs pour les opérations de mise à jour et suppression
    if (widget.formType == FormType.updateAdmin ||
        widget.formType == FormType.deleteAdmin ||
        widget.formType == FormType.updateUser ||
        widget.formType == FormType.deleteUser) {
      _emailController.text = 'emma.mcintyre@gmail.com';
      _nameController.text = 'Emma McIntyre';
      _phoneController.text = '**_**_**_**';
      _addressController.text = '123 Library Lane';

      // Pré-remplir les rôles seulement pour les admins
      if (widget.formType == FormType.updateAdmin ||
          widget.formType == FormType.deleteAdmin) {
        _isLibraryAdmin = true;
        _isLibraryAssistant = true;
        _isLibraryStaff = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121921),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2A3B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFB19E44),
            ),
            onPressed: () {
              // Action pour la notification
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Champ Email
                Text(
                  'Email',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'example@email.com',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1E2A3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    // MODIFICATION: Style des messages d'erreur
                    errorStyle: GoogleFonts.montserrat(
                      color: Colors.red[300],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (widget.formType != FormType.deleteAdmin &&
                        widget.formType != FormType.deleteUser &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter an email address';
                    }
                    if (widget.formType != FormType.deleteAdmin &&
                        widget.formType != FormType.deleteUser &&
                        !RegExp(r'\S+@\S+\.\S+').hasMatch(value!)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Champ Nom
                Text(
                  'Name',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Full Name',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1E2A3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    // MODIFICATION: Style des messages d'erreur
                    errorStyle: GoogleFonts.montserrat(
                      color: Colors.red[300],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (widget.formType != FormType.deleteAdmin &&
                        widget.formType != FormType.deleteUser &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Champ Téléphone
                Text(
                  'Phone Number',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: '**_**_**_**',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1E2A3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    // MODIFICATION: Style des messages d'erreur
                    errorStyle: GoogleFonts.montserrat(
                      color: Colors.red[300],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (widget.formType != FormType.deleteAdmin &&
                        widget.formType != FormType.deleteUser &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Champ Address
                Text(
                  'Address',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Full Address',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFF1E2A3B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    // MODIFICATION: Style des messages d'erreur
                    errorStyle: GoogleFonts.montserrat(
                      color: Colors.red[300],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  validator: (value) {
                    if (widget.formType != FormType.deleteAdmin &&
                        widget.formType != FormType.deleteUser &&
                        (value == null || value.isEmpty)) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Section Groupes / Rôles (Affiché seulement pour les admins)
                if (widget.formType == FormType.addAdmin ||
                    widget.formType == FormType.updateAdmin ||
                    widget.formType == FormType.deleteAdmin)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Groups / Roles',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Cases à cocher pour les rôles
                      CheckboxListTile(
                        title: Text(
                          'Library Administrator',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        value: _isLibraryAdmin,
                        onChanged: (value) {
                          setState(() {
                            _isLibraryAdmin = value!;
                          });
                        },
                        activeColor: const Color(0xFFB19E44),
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),

                      CheckboxListTile(
                        title: Text(
                          'Library Assistant',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        value: _isLibraryAssistant,
                        onChanged: (value) {
                          setState(() {
                            _isLibraryAssistant = value!;
                          });
                        },
                        activeColor: const Color(0xFFB19E44),
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),

                      CheckboxListTile(
                        title: Text(
                          'Library Staff',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        value: _isLibraryStaff,
                        onChanged: (value) {
                          setState(() {
                            _isLibraryStaff = value!;
                          });
                        },
                        activeColor: const Color(0xFFB19E44),
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Bouton d'action pour le formulaire
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() ||
                          widget.formType == FormType.deleteAdmin ||
                          widget.formType == FormType.deleteUser) {
                        print("Action triggered for ${widget.formType}:");
                        print('Email: ${_emailController.text}');
                        print('Name: ${_nameController.text}');
                        print('Phone: ${_phoneController.text}');
                        print('Address: ${_addressController.text}');

                        if (widget.formType == FormType.addAdmin ||
                            widget.formType == FormType.updateAdmin ||
                            widget.formType == FormType.deleteAdmin) {
                          print(
                            'Roles: Admin=$_isLibraryAdmin, Assistant=$_isLibraryAssistant, Staff=$_isLibraryStaff',
                          );
                        }

                        // MODIFICATION: Utilisation d'un SnackBar stylisé
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.formType == FormType.deleteAdmin ||
                                      widget.formType == FormType.deleteUser
                                  ? 'Successfully deleted!'
                                  : 'Information saved successfully!',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor:
                                widget.formType == FormType.deleteAdmin ||
                                        widget.formType == FormType.deleteUser
                                    ? Colors.red
                                    : const Color(0xFFB19E44),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          widget.formType == FormType.deleteAdmin ||
                                  widget.formType == FormType.deleteUser
                              ? Colors.red
                              : const Color(0xFFB19E44),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      widget.buttonText,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
