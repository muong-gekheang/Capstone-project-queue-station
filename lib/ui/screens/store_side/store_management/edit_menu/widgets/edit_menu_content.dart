import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/menu_form_widget.dart';

class EditMenuContent extends StatelessWidget {
  final MenuItem existingMenu;
  const EditMenuContent({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<MenuManagementViewModel>();
    return Scaffold(
      appBar: AppBarWidget(title: 'Edit Item', color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MenuForm(
          initialMenu: existingMenu, // not null because we are editing
          onSubmit: (MenuItem updatedMenu, Uint8List? pickedLogoBytes) {
            vm.updateMenuItem(updatedMenu, existingMenu, pickedLogoBytes);
            Navigator.pop(context); // close the page
          },
        ),
      ),
    );
  }
}
