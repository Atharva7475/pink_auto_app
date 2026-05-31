import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverDocumentUploadScreen extends StatefulWidget {
  const DriverDocumentUploadScreen({Key? key}) : super(key: key);

  @override
  State<DriverDocumentUploadScreen> createState() => _DriverDocumentUploadScreenState();
}

class _DriverDocumentUploadScreenState extends State<DriverDocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _drivingLicenseImage;
  XFile? _rcImage;
  XFile? _photographImage;
  XFile? _aadhaarImage;

  bool _isUploading = false;

  Future<void> _pickImage(String documentType) async {
    // Show dialog to choose between camera and gallery
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          switch (documentType) {
            case 'license':
              _drivingLicenseImage = image;
              break;
            case 'rc':
              _rcImage = image;
              break;
            case 'photograph':
              _photographImage = image;
              break;
            case 'aadhaar':
              _aadhaarImage = image;
              break;
          }
        });
      }
    }
  }

  bool _areAllDocumentsUploaded() {
    return _drivingLicenseImage != null &&
        _rcImage != null &&
        _photographImage != null &&
        _aadhaarImage != null;
  }

  Future<void> _submitDocuments() async {
    if (!_areAllDocumentsUploaded()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required documents.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    // Mark driver as registered
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDriverRegistered', true);

    if (!mounted) return;
    
    setState(() {
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documents uploaded successfully!')),
    );
    
    // Navigate to driver dashboard
    context.go('/driver-dashboard');
  }

  Widget _buildDocumentUploadTile({
    required String title,
    required String documentType,
    required XFile? imageFile,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: imageFile == null
            ? const Text('Not uploaded', style: TextStyle(color: Colors.red))
            : const Text('Uploaded', style: TextStyle(color: Colors.green)),
        trailing: imageFile == null
            ? const Icon(Icons.upload_file)
            : Image.file(
                File(imageFile.path),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
        onTap: () => _pickImage(documentType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: SafeArea(
        child: _isUploading
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading documents, please wait...'),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Please upload clear photos of the following documents to complete your registration.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  _buildDocumentUploadTile(
                    title: 'Driver Photograph',
                    documentType: 'photograph',
                    imageFile: _photographImage,
                  ),
                  _buildDocumentUploadTile(
                    title: 'Driving License (Auto)',
                    documentType: 'license',
                    imageFile: _drivingLicenseImage,
                  ),
                  _buildDocumentUploadTile(
                    title: 'Vehicle RC',
                    documentType: 'rc',
                    imageFile: _rcImage,
                  ),
                  _buildDocumentUploadTile(
                    title: 'Aadhaar Card',
                    documentType: 'aadhaar',
                    imageFile: _aadhaarImage,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitDocuments,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Submit & Finish Registration'),
                  ),
                ],
              ),
      ),
    );
  }
}
