import 'package:flutter/material.dart';

class CustomSuccessSnackbar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.white,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF22C58B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF22C58B),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF22C58B),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
