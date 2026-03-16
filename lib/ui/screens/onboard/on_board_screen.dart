import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.naturalWhite,
      body: Center(
        child: SizedBox(
          height: 150,
          width: 300,
          child: Image.asset("assets/queue_station.png", fit: BoxFit.cover),
        ),
      ),
    );
  }
}
