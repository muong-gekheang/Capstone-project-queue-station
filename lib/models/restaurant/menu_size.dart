import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';
import 'package:uuid/uuid.dart';

part 'menu_size.g.dart';

final _uuid = Uuid();

@JsonSerializable(explicitToJson: true)
class MenuSize {
  final String id;
  double price;
  final SizeOption sizeOption;

  MenuSize({String? id, required this.price, required this.sizeOption})
    : id = id ?? _uuid.v4();

  factory MenuSize.fromJson(Map<String, dynamic> json) =>
      _$MenuSizeFromJson(json);

  Map<String, dynamic> toJson() => _$MenuSizeToJson(this);
}
