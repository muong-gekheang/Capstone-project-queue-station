import 'package:json_annotation/json_annotation.dart';

part 'size_option.g.dart';

@JsonSerializable()
class SizeOption {
  final String name;
  const SizeOption({required this.name});

  factory SizeOption.fromJson(Map<String, dynamic> json) =>
      _$SizeOptionFromJson(json);

  Map<String, dynamic> toJson() => _$SizeOptionToJson(this);
}
