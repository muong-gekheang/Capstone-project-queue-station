import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/models/restaurant/size_option.dart';

part 'menu_size.g.dart';

@JsonSerializable(explicitToJson: true)
class MenuSize {
  double price;
  final SizeOption sizeOption;
  MenuSize({required this.price, required this.sizeOption});

  factory MenuSize.fromJson(Map<String, dynamic> json) =>
      _$MenuSizeFromJson(json);

  Map<String, dynamic> toJson() => _$MenuSizeToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuSize &&
          runtimeType == other.runtimeType &&
          sizeOption == other.sizeOption;

  @override
  int get hashCode => Object.hash(price, sizeOption);
}
