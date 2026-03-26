import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/store/auth_service.dart';
import 'package:queue_station_app/ui/screens/auth/view_model/auth_view_model.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/login_screen.dart';
import 'package:queue_station_app/ui/screens/auth/widgets/register_screen.dart';

enum AuthScreenTab { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthScreenTab selectedTab = AuthScreenTab.login;

  void onTap(AuthScreenTab authScreenTab) {
    setState(() {
      selectedTab = authScreenTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(authService: context.read<AuthService>()),
      child: IndexedStack(
        index: selectedTab.index,
        children: [
          LoginScreen(onSwitchTap: onTap),
          RegisterScreen(onSwitchTap: onTap),
        ],
      ),
    );
  }
}
