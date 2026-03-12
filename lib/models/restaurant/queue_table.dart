import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'queue_table.g.dart';

final _uuid = Uuid();

enum TableStatus { available, occupied }

@JsonSerializable(explicitToJson: true)
class QueueTable {
  final String id;
  final String tableNum;
  TableStatus tableStatus;
  final String tableCategoryId;

  @JsonKey(defaultValue: <String>[])
  final List<String> queueEntryIds;

  QueueTable({
    String? id,
    required this.tableNum,
    required this.tableStatus,
    required this.tableCategoryId,
    required this.queueEntryIds,
  }) : id = id ?? _uuid.v4();

  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    String? tableCategoryId,
    List<String>? queueEntryIds,
  }) {
    return QueueTable(
      id: id,
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategoryId: tableCategoryId ?? this.tableCategoryId,
      queueEntryIds: queueEntryIds ?? this.queueEntryIds,
    );
  }

  factory QueueTable.fromJson(Map<String, dynamic> json) =>
      _$QueueTableFromJson(json);

  Map<String, dynamic> toJson() => _$QueueTableToJson(this);
}
