import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final String? trailingText;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? borderColor; 
  final Color textColor;
  final double borderRadius;
  final EdgeInsets? padding;
  const ButtonWidget({
    super.key,
    this.leadingIcon,
    required this.title,
    this.trailingText,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.borderRadius = 50,
    this.borderColor,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(borderRadius),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1)
              : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child: trailingText == null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, color: textColor),
                const SizedBox(width: 5),
              ],
              Text(title, style: TextStyle(color: textColor)),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              Text(trailingText!, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
        );
  }
}
