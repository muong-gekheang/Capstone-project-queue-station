import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/store_queue_screen.dart';
import 'package:queue_station_app/services/queue_service.dart';
import '../../../../models/analytic/dashboard_stats.dart';
import '../../../widgets/dashboard_stats_grid.dart';
import '../../../widgets/store_profile_avatar.dart';
import '../../../../models/nav_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required void Function() onManageQueue});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadDashboardStats() async {
    try {
      await context.read<QueueService>().getDashboardStats();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startPeriodicRefresh() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        _loadDashboardStats();
        _startPeriodicRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Dashboard_blue.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          const StoreProfileAvatar(radius: 20),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              final orderService = context.read<OrderService>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Provider.value(
                    value: orderService,
                    child: const NotificationScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardStatsGrid(
                    stats: _stats,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        final restaurantService = context.read<RestaurantService>();
                        final queueService = context.read<QueueService>();
                        await Navigator.push<NavTab>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MultiProvider(
                              providers: [
                                Provider.value(value: restaurantService),
                                Provider.value(value: queueService),
                              ],
                              child: const StoreQueueScreen(isPushed: true),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Manage Queue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}