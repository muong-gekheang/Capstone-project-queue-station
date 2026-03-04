import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/mock_restaurant.dart';
import 'package:queue_station_app/services/restaurant_service.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/store_side/dashboard/view_model/dashboard_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/dashboard/widgets/dashboard_content.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.read<UserProvider>();
    RestaurantService restaurantService = context.read<RestaurantService>();
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(
        userProvider: userProvider,
        restaurantService: restaurantService,
      ),
      child: DashboardContent(),
    );
  }
}
