import 'package:flutter/material.dart';
import 'package:queue_station_app/data/menu_mock_data.dart';
import 'package:queue_station_app/old_model/menu.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_form_widget.dart';

class EditMenuScreen extends StatelessWidget {
  final Menu existingMenu;
  const EditMenuScreen({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Edit Item', color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MenuForm(
          initialMenu: existingMenu, // not null because we are editing
          onSubmit: (Menu updatedMenu) {
            final index = mockMenus.indexWhere(
              (m) => m.menuId == updatedMenu.menuId,
            );
            if (index != -1) {
              mockMenus[index] = updatedMenu;
            }
            Navigator.pop(context); // close the page
          },
        ),
      ),
    );
  }
}
