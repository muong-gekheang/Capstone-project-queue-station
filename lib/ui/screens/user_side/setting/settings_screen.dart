import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/repositories/auth/auth_repository.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/settings_content.dart';
import 'package:queue_station_app/ui/screens/user_side/setting/view_models/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(
        authRepository: context.read<AuthRepository>(), 
        userProvider: context.read<UserProvider>()
      ),
      child: SettingsContent(),
    );
  }
}
