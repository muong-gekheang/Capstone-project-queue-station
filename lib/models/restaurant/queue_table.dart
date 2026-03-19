import 'package:json_annotation/json_annotation.dart';
import 'package:queue_station_app/utils/nullable_timestamp_converter.dart';
import 'package:queue_station_app/utils/timestamp_converter.dart';
import 'package:uuid/uuid.dart';

part 'queue_table.g.dart';

const _uuid = Uuid();

enum TableStatus {
  @JsonValue('available')
  available,
  @JsonValue('occupied')
  occupied,
}

@JsonSerializable(explicitToJson: true)
class QueueTable {
  final String id;
  final String tableNum;
  final String restaurantId; // Added
  final String tableCategoryId;
  final TableStatus tableStatus;

  @JsonKey(defaultValue: [])
  final List<String> queueEntryIds;

  // Handles the ISO8601 string from your data
  @NullableTimestampConverter()
  final DateTime? latestEstimatedReadyAt; // Added

  QueueTable({
    String? id,
    required this.tableNum,
    required this.restaurantId,
    required this.tableStatus,
    required this.tableCategoryId,
    required this.queueEntryIds,
    this.latestEstimatedReadyAt,
  }) : id = id ?? _uuid.v4();

  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    String? tableCategoryId,
    List<String>? queueEntryIds,
    String? restaurantId,
    DateTime? latestEstimatedReadyAt,
  }) {
    return QueueTable(
      id: id,
      tableNum: tableNum ?? this.tableNum,
      restaurantId: restaurantId ?? this.restaurantId,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategoryId: tableCategoryId ?? this.tableCategoryId,
      queueEntryIds: queueEntryIds ?? this.queueEntryIds,
      latestEstimatedReadyAt:
          latestEstimatedReadyAt ?? this.latestEstimatedReadyAt,
    );
  }

  factory QueueTable.fromJson(Map<String, dynamic> json) =>
      _$QueueTableFromJson(json);

  Map<String, dynamic> toJson() => _$QueueTableToJson(this);
}
