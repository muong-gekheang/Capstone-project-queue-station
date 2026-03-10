import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/menu_item.dart';
import 'package:queue_station_app/services/store/menu_service.dart';

class EditMenuViewModel extends ChangeNotifier {
  final MenuService _menuService;

  EditMenuViewModel({required MenuService menuService})
    : _menuService = menuService;

  void updateMenuItem(MenuItem newMenuItem) {
    _menuService.updateMenuItem(newMenuItem);
  }
}
