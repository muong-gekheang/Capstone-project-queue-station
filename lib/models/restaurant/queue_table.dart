import 'package:json_annotation/json_annotation.dart';
import '../user/abstracts/user.dart';
import '../user/user_serialization.dart';
import 'table_category.dart';
import 'package:uuid/uuid.dart';

part 'queue_table.g.dart';

final uuid = Uuid();

enum TableStatus { available, occupied }

@JsonSerializable(explicitToJson: true)
class QueueTable {
  final String id;
  final String tableNum;
  TableStatus tableStatus;
  final TableCategory tableCategory;
  @JsonKey(fromJson: _usersFromJson, toJson: _usersToJson)
  final List<User> customers;
  final String? currentQueueEntryId;
  final DateTime? occupiedSince;

  QueueTable({
    String? id,
    required this.tableNum,
    required this.tableStatus,
    required this.tableCategory,
    List<User>? customers,
    this.currentQueueEntryId,
    this.occupiedSince,
  }) : id = id ?? uuid.v4(),
       customers = customers ?? [];

  // Copy method with ALL fields
  QueueTable copyWith({
    String? tableNum,
    TableStatus? tableStatus,
    TableCategory? tableCategory,
    List<User>? customers,
    String? currentQueueEntryId,
    DateTime? occupiedSince,
  }) {
    return QueueTable(
      id: id, // Keep same ID
      tableNum: tableNum ?? this.tableNum,
      tableStatus: tableStatus ?? this.tableStatus,
      tableCategory: tableCategory ?? this.tableCategory,
      customers: customers ?? this.customers,
      currentQueueEntryId: currentQueueEntryId ?? this.currentQueueEntryId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
    );
  }

  factory QueueTable.fromJson(Map<String, dynamic> json) =>
      _$QueueTableFromJson(json);

  Map<String, dynamic> toJson() => _$QueueTableToJson(this);
}

List<User> _usersFromJson(List<dynamic>? users) {
  if (users == null) return <User>[];
  return users
      .map((user) => userFromJson(user as Map<String, dynamic>))
      .toList();
}

List<Map<String, dynamic>> _usersToJson(List<User> users) {
  return users.map((user) => user.toJson()).toList();
}
