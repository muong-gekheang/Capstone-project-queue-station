import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';

class DeleteMenuPopUp extends StatelessWidget {
  final String message;
  final MenuItem menu;
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
                  TextSpan(text: '\n'),
                  TextSpan(
                    text: menu.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                image: menu.image != null
                    ? DecorationImage(image: AssetImage(menu.image!))
                    : DecorationImage(
                        image: AssetImage('assets/images/default_menu.jpg'),
                      ), // - will implement later
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  title: 'Cancel',
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: Colors.white,
                  textColor: AppTheme.secondaryColor,
                  borderColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 5,
                  ),
                ),
                const SizedBox(width: 20),
                ButtonWidget(
                  title: 'Delete',
                  onPressed: () => Navigator.pop(context, true),
                  backgroundColor: AppTheme.accentRed,
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
