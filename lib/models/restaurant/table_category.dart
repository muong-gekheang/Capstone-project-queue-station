import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'table_category.g.dart';

var uuid = Uuid();

@JsonSerializable()
class TableCategory {
  final String id;
  final String type;
  final int minSeat;
  final int seatAmount;

  TableCategory({
    @JsonKey(name: 'id') String? categoryId,
    required this.type,
    required this.minSeat,
    required this.seatAmount,
  }) : id = categoryId ?? uuid.v4();

  factory TableCategory.fromJson(Map<String, dynamic> json) =>
      _$TableCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TableCategoryToJson(this);

  static TableCategory? get small => null;

  static TableCategory? get standard => null;
}
