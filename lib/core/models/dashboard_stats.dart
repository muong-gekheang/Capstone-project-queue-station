class DashboardStats {
  final int queueEntries;
  final int peopleWaiting;
  final int activeTables;
  final int averageWaitTimeMinutes;

  DashboardStats({
    required this.queueEntries,
    required this.peopleWaiting,
    required this.activeTables,
    required this.averageWaitTimeMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'queueEntries': queueEntries,
      'peopleWaiting': peopleWaiting,
      'activeTables': activeTables,
      'averageWaitTimeMinutes': averageWaitTimeMinutes,
    };
  }

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      queueEntries: json['queueEntries'] as int,
      peopleWaiting: json['peopleWaiting'] as int,
      activeTables: json['activeTables'] as int,
      averageWaitTimeMinutes: json['averageWaitTimeMinutes'] as int,
    );
  }
}
