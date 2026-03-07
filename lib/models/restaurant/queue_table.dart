import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'table_category.dart';

part 'queue_table.g.dart';

final uuid = Uuid();

enum TableStatus { available, occupied }

@JsonSerializable(explicitToJson: true)
class QueueTable {
  final String id;
  final String tableNum;
  TableStatus tableStatus;
  final String tableCategoryId;

  @JsonKey(defaultValue: <String>[])
  final List<String> queueEntryIds;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final TableCategory tableCategory;

  QueueTable({
    String? id,
    required this.tableNum,
    required this.tableStatus,
    String? tableCategoryId,
    TableCategory? tableCategory,
    required List<String>? queueEntryIds,
  }) : id = id ?? uuid.v4(),
       tableCategoryId =
           tableCategoryId ?? tableCategory?.id ?? 'unknown_table_category',
       tableCategory =
           tableCategory ??
           TableCategory(
             categoryId:
                 tableCategoryId ?? tableCategory?.id ?? 'unknown_table_category',
             type: 'Unknown',
             minSeat: 1,
             seatAmount: 1,
           ),
       queueEntryIds = queueEntryIds ?? [];

  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    String? tableCategoryId,
    TableCategory? tableCategory,
    List<String>? queueEntryIds,
  }) {
    return QueueTable(
      id: id,
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategoryId: tableCategoryId ?? this.tableCategoryId,
      tableCategory: tableCategory ?? this.tableCategory,
      queueEntryIds: queueEntryIds ?? this.queueEntryIds,
    );
  }

  factory QueueTable.fromJson(Map<String, dynamic> json) =>
      _$QueueTableFromJson(json);

  Map<String, dynamic> toJson() => _$QueueTableToJson(this);
}
