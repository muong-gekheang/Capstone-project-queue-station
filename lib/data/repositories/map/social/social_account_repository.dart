import 'package:queue_station_app/models/restaurant/restaurant_social.dart';

abstract class SocialAccountRepository {
  Future<List<SocialAccount>> getAccountsByIds(List<String> ids);
  Future<void> saveAccount(SocialAccount account);
  Future<void> deleteAccount(String id);
}
