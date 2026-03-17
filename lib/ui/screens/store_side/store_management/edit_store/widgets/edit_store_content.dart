import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/view_model/edit_store_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/custom_success_snackbar.dart';

class EditStoreContent extends StatefulWidget {
  const EditStoreContent({super.key});

  @override
  State<EditStoreContent> createState() => _EditStoreContentState();
}

class _EditStoreContentState extends State<EditStoreContent> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();

  final TextEditingController _storeEmailController = TextEditingController();
  String _selectedBranch = "IFL";
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void onSave() async {
    EditStoreViewModel editStoreViewModel = context.read<EditStoreViewModel>();
    await editStoreViewModel.onSave(
      _selectedImage,
      _storeNameController.text,
      _storeDescriptionController.text,
    );
    if (context.mounted) {
      CustomSuccessSnackbar.show(context, "Added Successfully");
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _storeEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EditStoreViewModel editStoreViewModel = context.watch<EditStoreViewModel>();
    _storeNameController.text = editStoreViewModel.storeName;
    _storeDescriptionController.text = editStoreViewModel.storeDescription;
    _storeEmailController.text = editStoreViewModel.adminEmail;
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
                              color: _selectedImage == null
                                  ? const Color(0xFF0D47A1)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: _selectedImage != null
                                  ? Border.all(
                                      color: Colors.grey.shade300,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: _selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      width: 200,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  ),
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
                    label: "Email:",
                    isError: !editStoreViewModel.isEmailVerified,
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
                  const SizedBox(height: 10),

                  if (!editStoreViewModel.isEmailVerified)
                    FilledButton(
                      onPressed: () {
                        editStoreViewModel.sendVerifyEmail();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Email sent! \nPlease make sure this email is real.',
                            ),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                      child: Text("Verify email"),
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

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
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
}
