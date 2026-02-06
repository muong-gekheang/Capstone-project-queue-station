import 'package:flutter/material.dart';

class FullWidthFilledButton extends StatelessWidget {
  const FullWidthFilledButton({
    super.key,
    required this.onPress,
    required this.label,
  });

  final VoidCallback? onPress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      // onPressed: () => onJoinQueue(),
      onPressed: onPress,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 10),
        backgroundColor: Color(0xFFFF6835),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(0),
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 24)),
    );
  }
}
