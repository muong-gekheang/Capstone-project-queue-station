import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  Color? color;
  final Widget? trailing;
  final VoidCallback? onBackPressed;
  AppBarWidget({
    super.key,
    required this.title,
    this.color,
    this.trailing,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          onBackPressed ?? Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Color.fromRGBO(255, 104, 53, 1),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: true,
      actions: [
        if(trailing != null)
          Center(
            child: trailing,
          )
        
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
