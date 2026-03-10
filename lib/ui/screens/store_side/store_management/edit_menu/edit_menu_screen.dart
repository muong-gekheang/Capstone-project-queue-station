import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/view_model/edit_menu_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_menu/widgets/edit_menu_content.dart';

class EditMenuScreen extends StatelessWidget {
  final MenuItem existingMenu;
  const EditMenuScreen({super.key, required this.existingMenu});

  @override
  Widget build(BuildContext context) {
    MenuService menuService = context.read<MenuService>();
    return ChangeNotifierProvider(
      create: (_) => EditMenuViewModel(menuService: menuService),
      child: EditMenuContent(existingMenu: existingMenu),
    );
  }
}
