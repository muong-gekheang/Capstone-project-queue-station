import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData? leadingIcon;
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius; 
  final EdgeInsets? padding;
  const ButtonWidget({super.key, this.leadingIcon, required this.title, required this.onPressed, required this.backgroundColor, required this.textColor, this.borderRadius = 50, required this.padding});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(borderRadius)
        )
      ),
      onPressed: onPressed, 
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(leadingIcon != null)
              Icon(leadingIcon, color: textColor,),
            SizedBox(width: 3),
            Text(title, style: TextStyle(color: textColor),),
          ],
        ),
      )
    );
  }
}