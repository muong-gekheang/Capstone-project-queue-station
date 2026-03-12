import 'package:json_annotation/json_annotation.dart';


part 'restaurant.g.dart';

@JsonSerializable(explicitToJson: true)
class Restaurant {
  final String id;
  final String name;
  final String address;
  final String logoLink;
  final String policy;
  final int biggestTableSize;
  final String phone;

  @JsonKey(defaultValue: <String>[])
  final List<String> itemIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> tableIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> globalAddOnIds;
  @JsonKey(defaultValue: <String>[])
  final List<String> globalSizeOptionIds;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.logoLink,
    this.policy = '',
    required this.biggestTableSize,
    required this.phone,
    List<String>? itemIds,
    List<String>? tableIds,
    List<String>? globalAddOnIds,
    List<String>? globalSizeOptionIds,
    List<String>? currentInQueueIds,
  }) : itemIds = itemIds ?? [],
       tableIds = tableIds ?? [],
       globalAddOnIds = globalAddOnIds ?? [],
       globalSizeOptionIds = globalSizeOptionIds ?? [];

  Duration get averageWaitingTime => const Duration(hours: 1);

  @override
  bool operator ==(Object other) {
    return (other is Restaurant) &&
        (other.name == name &&
            other.id == id &&
            other.address == address &&
            other.phone == phone);
  }

  @override
  int get hashCode => Object.hash(name, address, phone);

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
