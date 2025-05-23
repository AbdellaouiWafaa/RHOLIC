import 'package:RHOLIC/components/screens/code_enter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';


class UploadScreen extends StatefulWidget {
  final String? username;
  const UploadScreen({super.key, this.username});

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

  bool _isProcessing = false;

  bool _isPDF(String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }

  void _showNotPDFError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Only PDF files are allowed. Please select a PDF document."),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> processAndNavigate() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate processing time
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isProcessing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Documents processed successfully!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    
    
    await Future.delayed(const Duration(seconds: 2));

    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpScreen(),
        ),
      );
    }
  }

  Future<void> _pickPDF() async {
    try {
      final XFile? pickedFile = await _picker.pickMedia();
      if (pickedFile != null) {
        final String path = pickedFile.path;
        final String fileName = pickedFile.name;
        
        debugPrint('Picked file: $fileName, path: $path');
        
        if (_isPDF(path)) {
          setState(() {
            selectedFilePath = path;
            selectedFileName = fileName;
          });
        } else {
          _showNotPDFError();
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  Future<void> _uploadReceiptAsPDF() async {
    try {
      final XFile? pickedFile = await _picker.pickMedia();
      if (pickedFile != null) {
        final String path = pickedFile.path;
        final String fileName = pickedFile.name;
        
        debugPrint('Picked receipt: $fileName, path: $path');
        
        if (_isPDF(path)) {
          setState(() {
            receiptPath = path;
            receiptName = fileName;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Receipt selected successfully"),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          _showNotPDFError();
        }
      }
    } catch (e) {
      debugPrint('Error picking receipt: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking receipt file: $e")),
      );
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
        title: const Text(
          "Upload Documents", 
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
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
                          const Icon(Icons.picture_as_pdf, color: Color.fromARGB(255, 165, 133, 36)),
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
                      final uri = Uri.parse(mapsUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
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
                          border: Border.all(color: const Color.fromARGB(255, 165, 133, 36), width: 1.5),
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
                    onTap: _uploadReceiptAsPDF,
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
                          const Icon(Icons.picture_as_pdf, color: Color.fromARGB(255, 165, 133, 36)),
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
                      onPressed: (selectedFilePath != null && selectedFileName != null) 
                        ? processAndNavigate
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 165, 133, 36),
                        disabledBackgroundColor: Colors.grey,
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
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color.fromARGB(255, 165, 133, 36)),
                    SizedBox(height: 20),
                    Text(
                      "Processing documents...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
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
                icon: Icons.picture_as_pdf,
                title: "Select PDF Document",
                description: "Choose a PDF file from your device",
                onTap: () async {
                  Navigator.pop(context);
                  await _pickPDF();
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
}


 
