import 'package:flutter/material.dart';

class CustomScreenView extends StatelessWidget {
  const CustomScreenView({
    super.key,
    required this.content,
    this.bottomNavigationBar,
  });

  final Widget content;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Get Queue", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
