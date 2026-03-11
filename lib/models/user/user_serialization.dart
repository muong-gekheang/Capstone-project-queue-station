import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/store_user.dart';

User userFromJson(Map<String, dynamic> json) {
  final userType = json['userType'] as String?;
  switch (userType) {
    case 'customer':
      return Customer.fromJson(json);
    case 'store':
      return StoreUser.fromJson(json);
    default:
      throw ArgumentError('Unknown userType: $userType');
  }
}
