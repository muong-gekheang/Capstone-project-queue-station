import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/menu_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/view_model/menu_management_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management/widgets/menu_management_content.dart';

class MenuManagementScreen extends StatelessWidget {
  const MenuManagementScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          MenuManagementViewModel(menuService: context.read<MenuService>()),
      child: MenuManagementContent(),
    );
  }
}
