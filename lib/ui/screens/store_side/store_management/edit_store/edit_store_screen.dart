import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/services/store/store_profile_service.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/view_model/edit_store_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/edit_store/widgets/edit_store_content.dart';

class EditStoreScreen extends StatelessWidget {
  final RestaurantService restaurantService;
  final StoreProfileService storeProfileService;
  const EditStoreScreen({
    super.key,
    required this.restaurantService,
    required this.storeProfileService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditStoreViewModel(
        restaurantService: restaurantService,
        storeProfileService: storeProfileService,
      ),
      child: EditStoreContent(),
    );
  }
}
