import 'package:flutter/material.dart';
import 'package:queue_station_app/old_model/menu.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';

class DeleteMenuPopUp extends StatelessWidget {
  final String message;
  final Menu menu;
  const DeleteMenuPopUp({super.key, required this.message, required this.menu});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(text: message),
                  TextSpan(
                    text: menu.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            if (menu.menuImage != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: MemoryImage(menu.menuImage!),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  title: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  textColor: const Color.fromRGBO(13, 71, 161, 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                ),
                const SizedBox(width: 20),
                ButtonWidget(
                  title: 'Delete',
                  onPressed: () => Navigator.pop(context, true),
                  backgroundColor: const Color.fromRGBO(230, 57, 70, 1),
                  textColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
