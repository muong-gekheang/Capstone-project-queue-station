import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/user/user_repository.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/custom_text_field.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/view_model/edit_store_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/custom_dialog.dart';
import 'package:queue_station_app/ui/widgets/custom_success_snackbar.dart';

class EditStoreContent extends StatefulWidget {
  const EditStoreContent({super.key});

  @override
  State<EditStoreContent> createState() => _EditStoreContentState();
}

class _EditStoreContentState extends State<EditStoreContent> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _policyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _openingTimeController = TextEditingController();
  final TextEditingController _closingTimeController = TextEditingController();

  final TextEditingController _storePasswordController =
      TextEditingController();

  final TextEditingController _storeEmailcontroller = TextEditingController();

  final TextEditingController _userEmailController = TextEditingController();

  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  void onSave() async {
    EditStoreViewModel editStoreViewModel = context.read<EditStoreViewModel>();

    final toContinue = await showPasswordDialog();
    if (toContinue != null && toContinue) {
      await editStoreViewModel.onSave(
        selectedImage: _selectedImage,
        newStoreName: _storeNameController.text,
        newAddress: _addressController.text,
        userEmail: _userEmailController.text,
        storeEmail: _storeEmailcontroller.text,
        password: _storePasswordController.text,
        newPolicy: _policyController.text,
        newPhone: _phoneController.text,
        newOpeningTime: int.tryParse(_openingTimeController.text) ?? 0,
        newClosingTime: int.tryParse(_closingTimeController.text) ?? 0,
      );
      if (mounted) {
        CustomSuccessSnackbar.show(context, "Added Successfully");
        Navigator.of(context).pop(true);
      }
    }
  }

  void onVerify() async {
    var editStoreViewModel = context.read<EditStoreViewModel>();
    final toContinue = await showPasswordDialog();
    if (toContinue != null && toContinue) {
      _storePasswordController.clear();
      editStoreViewModel.sendVerifyEmail(_storePasswordController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email sent! \nPlease make sure this email is real.'),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    }
  }

  Future<bool?> showPasswordDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: "Authentication Required",
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextField(
            obscureText: true,
            controller: _storePasswordController,
            label: 'Password',
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              "Proceed",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _addressController.dispose();
    _openingTimeController.dispose();
    _policyController.dispose();
    _phoneController.dispose();
    _closingTimeController.dispose();
    _userEmailController.dispose();
    _storeEmailcontroller.dispose();
    _storePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditStoreViewModel editStoreViewModel = context.watch<EditStoreViewModel>();
    _storeNameController.text = editStoreViewModel.storeName;
    _addressController.text = editStoreViewModel.storeDescription;
    _userEmailController.text = editStoreViewModel.adminEmail;
    _storeEmailcontroller.text = editStoreViewModel.storeEmail;
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
                      onTap: pickImageFromGallery,
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
                            child: buildProfileImage(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: pickImageFromGallery,
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
                    label: "Store Email:",
                    child: TextField(
                      controller: _storeEmailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ExpansionTile(
                    tilePadding: EdgeInsets.all(0),
                    leading: Icon(Icons.mode_rounded),
                    textColor: AppTheme.primaryColor,
                    title: Text("More store edit"),
                    children: [
                      _buildFormField(
                        label: "Address:",
                        child: TextField(
                          controller: _addressController,
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
                        label: "Policy:",
                        child: TextField(
                          controller: _policyController,
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
                        label: "Phone:",
                        child: TextField(
                          controller: _phoneController,
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
                        label: "Opening Time:",
                        child: TextField(
                          controller: _openingTimeController,
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
                        label: "Closing Time:",
                        child: TextField(
                          controller: _closingTimeController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildFormField(
                    label: "User Email:",
                    isError: !editStoreViewModel.isEmailVerified,
                    child: TextField(
                      controller: _userEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (!editStoreViewModel.isEmailVerified)
                    FilledButton(
                      onPressed: onVerify,
                      child: Text("Verify email"),
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
                    onPressed: onSave,
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

  Widget _buildFormField({
    required String label,
    required Widget child,
    bool isError = false,
  }) {
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
              border: Border.all(
                color: isError ? AppTheme.accentRed : Colors.grey.shade300,
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Future<void> pickImageFromGallery() async {
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

  Widget buildProfileImage() {
    if (_selectedImage != null) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      );
    } else if (_selectedImageBytes != null) {
      return ClipOval(
        child: Image.memory(
          _selectedImageBytes!,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      );
    } else {
      return const Center(
        child: Icon(
          Icons.store,
          size: 80,
          color: Colors.white,
        ),
      );
    }
  }

  void saveStoreProfile() {
    final storeService = StoreProfileService(userProvider: UserProvider(), userRepository: context.read<UserRepository<StoreUser>>());
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
