import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';

class StoreProfileAvatar extends StatelessWidget {
  final double radius;

  const StoreProfileAvatar({
    super.key,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final restaurantService = context.read<RestaurantService>();

    return StreamBuilder(
      stream: restaurantService.streamRestaurant,
      initialData: restaurantService.currentRest,
      builder: (context, snapshot) {
        final restaurant = snapshot.data;
        final name = restaurant?.name ?? '';
        final logo = restaurant?.logoLink ?? '';

        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFFFF6835).withValues(alpha: 0.1),
            backgroundImage: logo.isNotEmpty ? NetworkImage(logo) : null,
            child: logo.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'S',
                    style: TextStyle(
                      color: const Color(0xFFFF6835),
                      fontWeight: FontWeight.w600,
                      fontSize: radius * 0.8,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
