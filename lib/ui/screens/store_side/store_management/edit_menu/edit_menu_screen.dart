import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/widgets/edit_menu_content.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';

class EditMenuScreen extends StatelessWidget {
  final MenuItem existingMenu;
  const EditMenuScreen({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<MenuManagementViewModel>(),
      child: EditMenuContent(existingMenu: existingMenu),
    );
  }
}
