import 'dart:typed_data';

import 'package:flutter/material.dart';

class CategoryCardWidget extends StatelessWidget {
  final Uint8List? profile;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  const CategoryCardWidget({super.key, this.profile, required this.name, required this.isSelected, required this.onTap });

  @override
  Widget build(BuildContext context) {
    Color color = isSelected ? Color.fromRGBO(13, 71, 161, 1) : Colors.black.withOpacity(0.5);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            width: isSelected ? 1 : 0, 
            color: color ,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(profile != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(image: MemoryImage(profile!)),
                ),
              ),
            Text(name, style: TextStyle(fontSize: 12, color: color),)
          ],
        )),
    );
  }

}
