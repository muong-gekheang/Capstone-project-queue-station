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

  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final storeService = StoreProfileService();
    _storeNameController.text = storeService.storeName;
    _storeDescriptionController.text = "Chinese dine in restaurant";
    _storePasswordController.text = "********";
    _storeEmailController.text = "KungfuKitchen@gmail.com";

    // Restore the previously saved profile image so the screen doesn't
    // revert to the default placeholder on every navigation.
    if (kIsWeb) {
      _selectedImageBytes = storeService.storeProfileImageBytes;
    } else {
      _selectedImage = storeService.storeProfileImage;
    }
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
                      onChanged: (value) =>
                          setState(() => _selectedBranch = value!),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "功夫",
            style: TextStyle(
              color: Color(0xFFFF6835),
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          Text(
            "KUNGFU",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          Text(
            "KITCHEN",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 4),
          Text(
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
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImageBytes = bytes;
            _selectedImage = null;
          });
        } else {
          setState(() {
            _selectedImage = File(image.path);
            _selectedImageBytes = null;
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
    final storeService = StoreProfileService();
    storeService.setStoreName(_storeNameController.text);

    if (kIsWeb) {
      if (_selectedImageBytes != null) {
        storeService.setStoreProfileImageBytes(_selectedImageBytes);
      }
    } else {
      if (_selectedImage != null) {
        storeService.setStoreProfileImage(_selectedImage);
      }
    }

    // Show success message and then pop
    CustomSuccessSnackbar.show(context, "Store Updated Successfully");

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pop(); 
      }
    });
  }
}
