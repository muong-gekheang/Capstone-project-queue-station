import 'package:flutter/material.dart';
import 'package:queue_station_app/data/mock/menu_mock_data.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_form_widget.dart';

class EditMenuScreen extends StatelessWidget {
  final MenuItem existingMenu;
  const EditMenuScreen({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Edit Item', color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MenuForm(
          initialMenu: existingMenu, // not null because we are editing
          onSubmit: (MenuItem updatedMenu) {
            final index = allMenuItems.indexWhere(
              (m) => m.id == updatedMenu.id,
            );
            if (index != -1) {
              allMenuItems[index] = updatedMenu;
            }
            Navigator.pop(context); // close the page
          },
        ),
      ),
    );
  }
}
