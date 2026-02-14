import 'dart:typed_data';

class MenuCategory {
  int? categoryId;
  final String categoryName;
  Uint8List? categoryProfile;

  MenuCategory({
    this.categoryId,
    required this.categoryName,
    this.categoryProfile,
  });
}
