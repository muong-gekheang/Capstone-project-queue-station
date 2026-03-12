import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../services/store_profile_service.dart';
import '../../../widgets/custom_success_snackbar.dart';

class EditStoreScreen extends StatefulWidget {
  const EditStoreScreen({super.key});

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();
  final TextEditingController _storePasswordController =
      TextEditingController();
  final TextEditingController _storeEmailController = TextEditingController();
  String _selectedBranch = "IFL";

  // For mobile: File
  File? _selectedImage;
  // For web: Uint8List
  Uint8List? _selectedImageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with existing store data from service
    final storeService = StoreProfileService();
    _storeNameController.text = storeService.storeName;
    // You might want to store these in the service too
    _storeDescriptionController.text = "Chinese dine in restaurant";
    _storePasswordController.text = "********";
    _storeEmailController.text = "KungfuKitchen@gmail.com";
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _storePasswordController.dispose();
    _storeEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Store",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: Stack(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color:
                                  (_selectedImage == null &&
                                      _selectedImageBytes == null)
                                  ? const Color(0xFF0D47A1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border:
                                  (_selectedImage != null ||
                                      _selectedImageBytes != null)
                                  ? Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: _buildProfileImage(),
                          ),
                          // Edit icon overlay
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImageFromGallery,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D47A1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields with labels on left
                  _buildFormField(
                    label: "Name:",
                    child: TextField(
                      controller: _storeNameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildFormField(
                    label: "Description:",
                    child: TextField(
                      controller: _storeDescriptionController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildFormField(
                    label: "Branch:",
                    child: DropdownButton<String>(
                      value: _selectedBranch,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down),
                      items: const [
                        DropdownMenuItem(value: "IFL", child: Text("IFL")),
                        DropdownMenuItem(
                          value: "Daun Penh",
                          child: Text("Daun Penh"),
                        ),
                        DropdownMenuItem(
                          value: "Eden Garden",
                          child: Text("Eden Garden"),
                        ),
                        DropdownMenuItem(
                          value: "Aeon Mall Phnom Penh 1",
                          child: Text("Aeon Mall Phnom Penh 1"),
                        ),
                        DropdownMenuItem(value: "BKK", child: Text("BKK")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBranch = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildFormField(
                    label: "Password:",
                    child: TextField(
                      controller: _storePasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildFormField(
                    label: "Email:",
                    child: TextField(
                      controller: _storeEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFF0D47A1),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.close, color: Color(0xFF0D47A1), size: 20),
                        SizedBox(width: 8),
                        Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFF0D47A1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Save Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveStoreProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6835),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (kIsWeb) {
      // Web: Use MemoryImage if bytes are available
      if (_selectedImageBytes != null) {
        return ClipOval(
          child: Image.memory(
            _selectedImageBytes!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      }
    } else {
      // Mobile: Use FileImage if file is available
      if (_selectedImage != null) {
        return ClipOval(
          child: Image.file(
            _selectedImage!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      }
    }

    // Default placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "功夫",
            style: TextStyle(
              color: Color(0xFFFF6835),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const Text(
            "KUNGFU",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Text(
            "KITCHEN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "MODERN CHINESE CUISINE & HOT POT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (kIsWeb) {
          // For web: read as bytes
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null; // Clear file for web
          });
        } else {
          // For mobile: use file
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null; // Clear bytes for mobile
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveStoreProfile() {
    // Save store profile to service
    final storeService = StoreProfileService();

    // Update store name
    storeService.setStoreName(_storeNameController.text);

    // Update profile image based on platform
    if (kIsWeb) {
      // For web: save bytes
      if (_selectedImageBytes != null) {
        storeService.setStoreProfileImageBytes(_selectedImageBytes);
      }
    } else {
      // For mobile: save file
      if (_selectedImage != null) {
        storeService.setStoreProfileImage(_selectedImage);
      }
    }

    // Show success message
    CustomSuccessSnackbar.show(context, "Store Updated Successfully");

    // Return to previous screen with success indication
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
  }
}
