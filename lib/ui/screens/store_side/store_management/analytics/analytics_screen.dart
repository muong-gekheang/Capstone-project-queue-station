import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/view_model/analytics_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/analytics/widgets/analytics_content.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsViewModel(),
      child: AnalyticsContent(),
    );
  }
}
