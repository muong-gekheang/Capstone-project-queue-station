import 'dart:typed_data';
import 'package:queue_station_app/domain/menu.dart';


class MenuCategory {
  int? categoryId;
  final String categoryName;
  Uint8List? categoryProfile;

  MenuCategory({this.categoryId, required this.categoryName, this.categoryProfile});

}
