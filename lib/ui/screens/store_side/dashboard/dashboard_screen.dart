import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:queue_station_app/data/queue_repository.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/notification_service.dart';
import 'package:queue_station_app/ui/screens/store_side/manage/store_queue_screen.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import '../../../../models/analytic/dashboard_stats.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store_profile_service.dart';
import 'package:flutter/foundation.dart';
import '../../../widgets/dashboard_stat_card.dart';
import '../../../../models/nav_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final QueueService _queueService = QueueService(QueueRepository());
  late final StoreProfileService _storeService;
  DashboardStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _storeService = StoreProfileService();
    _storeService.addListener(_onProfileChanged);
    _loadDashboardStats();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _storeService.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  void _loadDashboardStats() async {
    try {
      final stats = await _queueService.getDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
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
          _buildStoreProfileImage(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DashboardStatCard(
                    label: 'Queue Status',
                    value: '${_stats?.queueEntries ?? 0}',
                    unit: 'entries',
                  ),
                  const SizedBox(height: 12),
                  DashboardStatCard(
                    label: 'People Waiting',
                    value: '${_stats?.peopleWaiting ?? 0}',
                    unit: '',
                  ),
                  const SizedBox(height: 12),
                  DashboardStatCard(
                    label: 'Active Tables',
                    value: '${_stats?.activeTables ?? 0}',
                    unit: '',
                  ),
                  const SizedBox(height: 12),
                  DashboardStatCard(
                    label: 'Average Wait Time',
                    value: '${_stats?.averageWaitTimeMinutes ?? 0}',
                    unit: 'min',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push<NavTab>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const StoreQueueScreen(isPushed: true),
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

                  // ── Debug-only notification test panel ──────────────────
                  if (kDebugMode) ...[
                    const SizedBox(height: 32),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '🧪 Notification Test Panel (debug only)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    _DebugNotificationButton(
                      label: 'Simulate New Order (store)',
                      color: const Color(0xFF0D47A1),
                      onPressed: () => NotificationService().notifyStoreOfNewOrder(
                        tableNumber: 'B202',
                        queueNumber: 'A123',
                        itemCount: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DebugNotificationButton(
                      label: 'Simulate Order Update (store)',
                      color: const Color(0xFF1976D2),
                      onPressed: () => NotificationService().notifyStoreOfOrderUpdate(
                        tableNumber: 'B202',
                        queueNumber: 'A123',
                        itemCount: 5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _DebugNotificationButton(
                      label: 'Simulate Queue Joined (customer)',
                      color: const Color(0xFFFF6835),
                      onPressed: () => NotificationService().notifyCustomerQueueJoined(
                        QueueEntry(
                          id: 'test-${DateTime.now().millisecondsSinceEpoch}',
                          queueNumber: 'A999',
                          restId: 'mock-store-1',
                          customerId: 'test-customer',
                          partySize: 2,
                          joinTime: DateTime.now(),
                          status: QueueStatus.waiting,
                          joinedMethod: JoinedMethod.remote,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildStoreProfileImage() {
    final storeName = _storeService.storeName;

    ImageProvider? imageProvider;
    if (kIsWeb) {
      final bytes = _storeService.storeProfileImageBytes;
      if (bytes != null) imageProvider = MemoryImage(bytes);
    } else {
      final file = _storeService.storeProfileImage;
      if (file != null) imageProvider = FileImage(file);
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFFFF6835).withValues(alpha: 0.1),
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? Text(
                storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Color(0xFFFF6835),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )
            : null,
      ),
    );
  }
}

// ── Private helper widget used only by the debug test panel ───────────────────
class _DebugNotificationButton extends StatelessWidget {
  const _DebugNotificationButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
