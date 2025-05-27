import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class UploadService {
  static const String backendBaseUrl = 'https://backendapp-production-3be4.up.railway.app';
  
  /// Uploads a PDF file and optional receipt to the backend
  static Future<Map<String, dynamic>> uploadFiles({
    required String pdfPath,
    required String pdfName,
    String? receiptPath,
    String? receiptName,
    required String email,
    required Function(String) onProgress,
  }) async {
    final url = Uri.parse('$backendBaseUrl/api/upload-pdf');
    final request = http.MultipartRequest('POST', url);
    
    try {
      // Add important headers for proper multipart form data
      request.headers['Accept'] = 'application/json';
      request.headers['Connection'] = 'keep-alive';
      
      // Add PDF file - ensure it exists
      final pdfFile = File(pdfPath);
      if (!await pdfFile.exists()) {
        return {'success': false, 'message': 'PDF file not found'};
      }
      
      // Add PDF as multipart file with correct field name
      onProgress('Adding PDF file (${(await pdfFile.length()) ~/ 1024} KB)...');
      final pdfMultipart = await http.MultipartFile.fromPath(
        'pdf', 
        pdfPath,
        filename: pdfName
      );
      request.files.add(pdfMultipart);
      
      // Add receipt file if available 
      if (receiptPath != null && receiptName != null) {
        final receiptFile = File(receiptPath);
        if (await receiptFile.exists()) {
          onProgress('Adding receipt file (${(await receiptFile.length()) ~/ 1024} KB)...');
          final receiptMultipart = await http.MultipartFile.fromPath(
            'receipt', 
            receiptPath,
            filename: receiptName
          );
          request.files.add(receiptMultipart);
        }
      }
      
      // Add email field - crucial for backend identification
      request.fields['email'] = email;
      request.fields['fileName'] = pdfName;
      // Add this new line to include the original_filename field
      request.fields['original_filename'] = pdfName;
      
      // Debug output for troubleshooting
      debugPrint('Uploading to URL: ${request.url}');
      debugPrint('Request fields: ${request.fields}');
      debugPrint('Request files: ${request.files.map((f) => '${f.field}: ${f.filename} (${f.length} bytes)').join(', ')}');
      
      // Send the request
      onProgress('Sending files to server...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      // Handle the response
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Files uploaded successfully'};
      } else {
        String errorMessage = 'Upload failed (${response.statusCode})';
        try {
          final responseData = jsonDecode(response.body);
          errorMessage = responseData['message'] ?? errorMessage;
        } catch (e) {
          // If not JSON or parsing fails, use the raw body
          if (response.body.isNotEmpty) {
            errorMessage += ': ${response.body}';
          }
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (error) {
      debugPrint('Upload error: $error');
      return {'success': false, 'message': 'Error during upload: $error'};
    }
  }
}