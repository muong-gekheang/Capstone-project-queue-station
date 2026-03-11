import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText,
    this.borderRadius,
  });
  final TextEditingController controller;
  final String label;
  final bool? obscureText;
  final double? borderRadius;

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      fillColor: AppTheme.naturalWhite,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppTheme.borderRadiusS,
        ),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(Object context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppTheme.borderRadiusS,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.naturalBlack.withAlpha((255 * 0.25).toInt()),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText ?? false,
        controller: controller,
        decoration: _inputStyle(label),
      ),
    );
  }
}
