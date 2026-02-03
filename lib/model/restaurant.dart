class Restaurant {
  final String name;
  final String address;
  final String logoLink;
  final String policy;
  final int biggestTableSize;
  final String phone;
  const Restaurant({
    required this.name,
    required this.address,
    required this.logoLink,
    String? policy,
    required this.biggestTableSize,
    required this.phone,
  }) : policy = policy ?? "";

  Duration get averageWaitingTime => Duration(hours: 1);
  // TO DO
  int get curWait => 10;
}
