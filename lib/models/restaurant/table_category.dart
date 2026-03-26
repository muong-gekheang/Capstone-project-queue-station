import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'table_category.g.dart';

var uuid = Uuid();

@JsonSerializable()
class TableCategory {
  final String id;
  final String type;
  final String restaurantId;
  final int minSeat;

  final int seatAmount;

  TableCategory({
    String? id,
    required this.type,
    required this.minSeat,
    required this.seatAmount,
    required this.restaurantId,
  }) : id = id ?? uuid.v4();

  TableCategory copyWith({
    String? type,
    int? minSeat,
    int? seatAmount,
    String? restaurantId,
  }) {
    return TableCategory(
      id: id, // Keep the same ID
      type: type ?? this.type,
      minSeat: minSeat ?? this.minSeat,
      seatAmount: seatAmount ?? this.seatAmount,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  factory TableCategory.fromJson(Map<String, dynamic> json) =>
      _$TableCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$TableCategoryToJson(this);

  static TableCategory? get small => null;

  static TableCategory? get standard => null;
}
