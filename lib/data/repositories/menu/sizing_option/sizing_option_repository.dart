import 'package:queue_station_app/models/restaurant/size_option.dart';

abstract class SizingOptionRepository {
  Future<void> create(SizeOption newSizeOption);
  Future<void> delete(String sizeOptionId);
  Future<SizeOption?> getById(String sizeOptionId);
  Stream<List<SizeOption>> watchAllSizeOptions(String restaurantId);
}
