import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// Removed unused import: 'dart:convert';

const String backendBaseUrl ='https://backendapp-production-3be4.up.railway.app';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final String paymentCode = "0023456789 45"; 
  final String mapsUrl = "https://maps.app.goo.gl/oKo7S2rS1sTKQZoL6"; 
  final ImagePicker _picker = ImagePicker();

  bool showCodeBar = false;
  String? selectedFilePath;
  String? selectedFileName;
  String? receiptPath;
  String? receiptName;
  
  bool _isUploading = false;

  Future<void> uploadFileToBackend(String filePath, String fileName) async {
    setState(() {
      _isUploading = true;
    });

    final url = Uri.parse('$backendBaseUrl/api/upload-pdf');
    final request = http.MultipartRequest('POST', url);

    try {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.fields['fileName'] = fileName;

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Files uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to upload files: ${response.reasonPhrase}"),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("An error occurred: $error")));
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 15, 58),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 15, 58),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 165, 133, 36)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildUploadButton("If you are a student", "Upload here", () {
                    _showUploadOptions(context, isStudent: true);
                  }),
                  const SizedBox(height: 20),
                  _buildUploadButton("If you are a worker", "Upload here", () {
                    _showUploadOptions(context, isStudent: false);
                  }),
                  
                  
                  if (selectedFileName != null)
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 30, 80),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color.fromARGB(255, 165, 133, 36)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.file_present, color: Color.fromARGB(255, 165, 133, 36)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Selected: $selectedFileName",
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () {
                              setState(() {
                                selectedFileName = null;
                                selectedFilePath = null;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      disabledBackgroundColor: const Color.fromARGB(255, 20, 97, 173),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const SizedBox(
                      height: 60,
                      width: 200,
                      child: Center(
                        child: Text("PAYMENT WAYS:", style: TextStyle(color: Colors.white70, fontSize: 22)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                 
                  _buildClickableRow(
                    icon: Icons.place,
                    title: "Please visit our library location",
                    linkText: "here",
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(mapsUrl))) {
                        await launchUrl(Uri.parse(mapsUrl));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Could not open Google Maps")),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  _buildClickableRow(
                    icon: Icons.credit_card_outlined,
                    title: "Our CCP number for payment",
                    linkText: "here",
                    onTap: () {
                      setState(() {
                        showCodeBar = true;
                      });
                    },
                  ),

                  const SizedBox(height: 5),

                  if (showCodeBar)
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: paymentCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("CCP number copied to clipboard!"),
                            duration: Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        margin: const EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 20, 30, 80),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color.fromARGB(255, 165, 133, 36), width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              paymentCode,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 165, 133, 36),
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.copy, color: Color.fromARGB(255, 165, 133, 36)),
                          ],
                        ),
                      ),
                    ),
                    
                 
                  const SizedBox(height: 20),
                  _buildClickableRow(
                    icon: Icons.receipt_long,
                    title: "Upload payment receipt",
                    linkText: "upload",
                    onTap: _uploadReceipt,
                  ),
                  
                 
                  if (receiptName != null)
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 20, 30, 80),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color.fromARGB(255, 165, 133, 36)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.receipt, color: Color.fromARGB(255, 165, 133, 36)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Receipt: $receiptName",
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white70),
                            onPressed: () {
                              setState(() {
                                receiptName = null;
                                receiptPath = null;
                              });
                            },
                          )
                        ],
                      ),
                    ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedFilePath != null && selectedFileName != null) {
                          await uploadFileToBackend(selectedFilePath!, selectedFileName!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No file selected to upload.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(13.0),
                        child: Text("Done", style: TextStyle(fontSize: 22, color: Colors.white)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
          if (_isUploading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color.fromARGB(255, 165, 133, 36)),
              ),
            ),
        ],
      ),
    );
  }

 
  void _uploadReceipt() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        receiptPath = image.path;
        receiptName = image.name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Receipt uploaded successfully"),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildUploadButton(String title, String buttonText, VoidCallback onPressed) {
    return Row(
      children: [
        const Icon(Icons.upload_file, color: Colors.lightBlue),
        const SizedBox(width: 30),
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 25)),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText, style: const TextStyle(color: Colors.lightBlue)),
        ),
      ],
    );
  }

  Widget _buildClickableRow({
    required IconData icon,
    required String title,
    required String linkText,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 20),
        Expanded(
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20)),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(linkText, style: const TextStyle(color: Colors.lightBlue, fontSize: 16)),
        ),
      ],
    );
  }

  void _showUploadOptions(BuildContext context, {required bool isStudent}) {
    final String userType = isStudent ? "Student" : "Worker";
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 20, 30, 80),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$userType Upload Options",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
             
              _buildOptionTile(
                icon: Icons.camera_alt,
                title: "Take Photo",
                description: "Use your camera to take a picture of your document",
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                  if (photo != null) {
                    setState(() {
                      selectedFilePath = photo.path;
                      selectedFileName = photo.name;
                    });
                  }
                },
              ),
              
              const Divider(color: Colors.white24),
              
              
              _buildOptionTile(
                icon: Icons.photo_library,
                title: "Choose from Gallery",
                description: "Select an existing image from your gallery",
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      selectedFilePath = image.path;
                      selectedFileName = image.name;
                    });
                  }
                },
              ),
              
              const Divider(color: Colors.white24),
              
              
              // Email option
              _buildOptionTile(
                icon: Icons.email,
                title: "Email Your Document",
                description: "Send your document to our email address",
                onTap: () {
                  Navigator.pop(context);
                  _showEmailInstructionsDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 165, 133, 36),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      subtitle: Text(
        description,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: onTap,
    );
  }

  void _showEmailInstructionsDialog(BuildContext context) {
    final String emailAddress = "RHOLIC@gmail.com";
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 20, 30, 80),
        title: const Text("Email Your Document", 
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please send your document to the following email address:",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 15, 58),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color.fromARGB(255, 165, 133, 36)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    emailAddress,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 165, 133, 36),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, color: Color.fromARGB(255, 165, 133, 36)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: emailAddress));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email copied to clipboard")),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Include your full name and ID in the subject line. We'll process your document within 24-48 hours.",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 165, 133, 36),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: emailAddress,
                query: 'subject=Document Upload - [Your Name]&body=Please find my document attached.',
              );
              
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not open email app")),
                );
              }
            },
            child: const Text("Open Email App", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedFileName = "Email submission planned";
                selectedFilePath = "email";
              });
              Navigator.pop(context);
            },
            child: const Text("I'll Email Later", style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}