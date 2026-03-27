import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14,),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
