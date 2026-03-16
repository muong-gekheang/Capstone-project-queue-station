import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/ui/screens/store_side/settings/view_model/store_settings_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/settings/widgets/store_settings_content.dart';

class StoreSettingsScreen extends StatelessWidget {
  const StoreSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          StoreSettingsViewModel(authService: context.read<AuthService>()),
      child: StoreSettingsContent(),
    );
  }
}
