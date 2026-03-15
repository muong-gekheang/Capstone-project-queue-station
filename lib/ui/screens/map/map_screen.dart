import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/restaurant/restaurant_repository.dart';
import 'package:queue_station_app/ui/screens/map/map_content/map_content.dart';
import 'package:queue_station_app/ui/screens/map/map_view_model/map_view_model.dart';

class MapScreen extends StatelessWidget {
  final String? ownRestaurantId;
  final String? initialRestaurantId;

  const MapScreen({super.key, this.ownRestaurantId, this.initialRestaurantId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapViewModel(
        repository: context.read<RestaurantRepository>(),
        ownRestaurantId: ownRestaurantId,
        initialRestaurantId: initialRestaurantId,
      ),
      child: const MapContent(),
    );
  }
}
