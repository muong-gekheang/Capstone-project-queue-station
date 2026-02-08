import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditorWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final File? selectedImage;
  const ProfileEditorWidget({super.key, required this.onEdit, required this.selectedImage});


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 90,
          backgroundColor: Colors.grey.shade100,
          backgroundImage: selectedImage != null
              ? FileImage(selectedImage!)
              : null,
          child: selectedImage == null
              ? const Icon(Icons.person, size: 120, color: Colors.grey)
              : null,
        ),
        Positioned(
          bottom: 10,
          right: 14,
          child: InkWell(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
