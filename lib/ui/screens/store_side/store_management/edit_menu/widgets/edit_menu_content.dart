import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/view_model/edit_menu_view_model.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/menu_form_widget.dart';

class EditMenuContent extends StatelessWidget {
  final MenuItem existingMenu;
  const EditMenuContent({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<EditMenuViewModel>();
    return Scaffold(
      appBar: AppBarWidget(title: 'Edit Item', color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MenuForm(
          initialMenu: existingMenu, // not null because we are editing
          onSubmit: (MenuItem updatedMenu) {
            vm.updateMenuItem(updatedMenu);
            Navigator.pop(context); // close the page
          },
        ),
      ),
    );
  }
}
