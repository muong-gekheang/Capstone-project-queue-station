import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/menu_form_widget.dart';

class AddNewMenu extends StatelessWidget {
  const AddNewMenu({super.key});

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<MenuManagementViewModel>();
    return Scaffold(
      appBar: AppBarWidget(title: "Add Menu Item", color: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ChangeNotifierProvider.value(
          value: vm,
          child: MenuForm(
            initialMenu: null, // null = we are adding
            onSubmit: (MenuItem newMenu) {
              vm.addMenuItem(newMenu);
              Navigator.pop(context); // close the page
            },
          ),
        ),
      ),
    );
  }
}
