class Table {
  final String id;
  final String tableNumber;
  final int capacity;
  final String status; // 'available', 'occupied', 'reserved'
  final String? currentQueueEntryId;
  final DateTime? occupiedSince;

  Table({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.status,
    this.currentQueueEntryId,
    this.occupiedSince,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tableNumber': tableNumber,
      'capacity': capacity,
      'status': status,
      'currentQueueEntryId': currentQueueEntryId,
      'occupiedSince': occupiedSince?.toIso8601String(),
    };
  }

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'] as String,
      tableNumber: json['tableNumber'] as String,
      capacity: json['capacity'] as int,
      status: json['status'] as String,
      currentQueueEntryId: json['currentQueueEntryId'] as String?,
      occupiedSince: json['occupiedSince'] != null
          ? DateTime.parse(json['occupiedSince'] as String)
          : null,
    );
  }

  Table copyWith({
    String? id,
    String? tableNumber,
    int? capacity,
    String? status,
    String? currentQueueEntryId,
    DateTime? occupiedSince,
  }) {
    return Table(
      id: id ?? this.id,
      tableNumber: tableNumber ?? this.tableNumber,
      capacity: capacity ?? this.capacity,
      status: status ?? this.status,
      currentQueueEntryId: currentQueueEntryId ?? this.currentQueueEntryId,
      occupiedSince: occupiedSince ?? this.occupiedSince,
    );
  }
}
