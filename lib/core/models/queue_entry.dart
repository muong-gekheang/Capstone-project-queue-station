class QueueEntry {
  final String id;
  final String customerName;
  final String customerPhone;
  final int partySize;
  final DateTime joinTime;
  final DateTime? servedTime;
  final String status; // 'waiting', 'served', 'cancelled'
  final String? tableNumber;

  QueueEntry({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.partySize,
    required this.joinTime,
    this.servedTime,
    required this.status,
    this.tableNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'partySize': partySize,
      'joinTime': joinTime.toIso8601String(),
      'servedTime': servedTime?.toIso8601String(),
      'status': status,
      'tableNumber': tableNumber,
    };
  }

  factory QueueEntry.fromJson(Map<String, dynamic> json) {
    return QueueEntry(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      partySize: json['partySize'] as int,
      joinTime: DateTime.parse(json['joinTime'] as String),
      servedTime: json['servedTime'] != null
          ? DateTime.parse(json['servedTime'] as String)
          : null,
      status: json['status'] as String,
      tableNumber: json['tableNumber'] as String?,
    );
  }

  QueueEntry copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    int? partySize,
    DateTime? joinTime,
    DateTime? servedTime,
    String? status,
    String? tableNumber,
  }) {
    return QueueEntry(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      partySize: partySize ?? this.partySize,
      joinTime: joinTime ?? this.joinTime,
      servedTime: servedTime ?? this.servedTime,
      status: status ?? this.status,
      tableNumber: tableNumber ?? this.tableNumber,
    );
  }
}
