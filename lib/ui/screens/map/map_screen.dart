import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/map/map_repository.dart';
import 'package:queue_station_app/data/repositories/map/social/social_account_repository.dart';
import 'package:queue_station_app/data/repositories/queue_entry/queue_entry_repository.dart';
import 'package:queue_station_app/models/restaurant/restaurant_social.dart';
import 'package:queue_station_app/services/queue_service.dart';
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
        repository: context.read<MapRepository>(),
        socialRepository: context.read<SocialAccountRepository>(),
        // queueService: context.read<QueueService>(),
        queueRepo: context.read<QueueEntryRepository>(),
        ownRestaurantId: ownRestaurantId,
        initialRestaurantId: initialRestaurantId,
      ),
      child: const MapContent(),
    );
  }
}
