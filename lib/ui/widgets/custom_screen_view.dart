import 'package:flutter/material.dart';

class CustomScreenView extends StatelessWidget {
  const CustomScreenView({
    super.key,
    required this.content,
    this.bottomNavigationBar,
    this.title,
    this.isTitleCenter,
    this.automaticImplyLeading,
  });

  final String? title;
  final bool? isTitleCenter;
  final bool? automaticImplyLeading;
  final Widget content;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: title != null
            ? Text(title!, style: TextStyle(fontWeight: FontWeight.bold))
            : null,
        centerTitle: isTitleCenter,
        automaticallyImplyLeading: automaticImplyLeading ?? true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: content,
        ),
      ),
      bottomNavigationBar: bottomNavigationBar != null
          ? SafeArea(child: bottomNavigationBar!)
          : null,
    );
  }
}
