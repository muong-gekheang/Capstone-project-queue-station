import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'table_category.g.dart';

final _uuid = Uuid();

@JsonSerializable()
class TableCategory {
  final String id;
  final String type;
  final int minSeat;
  final int seatAmount;

  TableCategory({
    String? categoryId,
    required this.type,
    required this.minSeat,
    required this.seatAmount, required String id,
  }) : id = categoryId ?? _uuid.v4();

  factory TableCategory.fromJson(Map<String, dynamic> json) =>
      _$TableCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TableCategoryToJson(this);
}
