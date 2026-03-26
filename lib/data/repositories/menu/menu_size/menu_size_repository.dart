import 'package:queue_station_app/models/restaurant/menu_size.dart';

abstract class MenuSizeRepository {
  Future<void> create(MenuSize menuSize);

  Future<void> update(MenuSize menuSize);

  Future<void> delete(String menuSizeId);

  Future<MenuSize?> getMenuSizeById(String menuSizeId);
}
