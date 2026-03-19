import 'dart:io';
import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class ProfileEditorWidget extends StatelessWidget {
  final ImageProvider? image; // current image to display (from VM)
  final VoidCallback onPickImage; // callback when user taps edit

  const ProfileEditorWidget({
    super.key,
    required this.image,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80, 
          backgroundColor: Colors.grey[200],
          backgroundImage: image,
          child: image == null
              ? const Icon(Icons.image, size: 50, color: AppTheme.naturalTextGrey)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onPickImage,
            child: const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(Icons.edit, size: 15, color: AppTheme.secondaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
