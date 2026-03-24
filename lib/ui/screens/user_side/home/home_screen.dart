import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/restaurants_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/home/view_models/home_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/home/widgets/home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(
        userProvider: context.read<UserProvider>(),
        queueService: context.read<QueueService>(),
        restaurantService: context.read<RestaurantListService>()
      ),
      child: HomeContent(),
    );
  }
}

