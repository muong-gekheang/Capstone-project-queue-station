import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/nav_tab.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/navigation_service.dart';
import 'package:queue_station_app/services/store_order_notification_provider.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/dashboard/dashboard_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/manage/store_queue_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/settings/store_settings_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/manage_store_screen.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/store_side_bottom_nav.dart';

class StoreMainScreen extends StatefulWidget {
  final User user;
  const StoreMainScreen({super.key, required this.user});
  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  NavTab _selectedTab = NavTab.dashboard;
  int _lastNotificationCount = 0;
  OverlayEntry? _bannerOverlay;

  List<Widget> get _screens => [
    DashboardScreen(),
    ManageStorePage(),
    const StoreQueueScreen(isPushed: false),
    StoreSettingsScreen(user: widget.user),
  ];

  void _onTabSelected(NavTab tab) {
    setState(() => _selectedTab = tab);
  }

  int _getTabIndex(NavTab tab) {
    switch (tab) {
      case NavTab.dashboard:
        return 0;
      case NavTab.analytics:
        return 1;
      case NavTab.queue:
        return 2;
      case NavTab.settings:
        return 3;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StoreOrderNotificationProvider>();
      _lastNotificationCount = provider.queueEntries.length;
      provider.addListener(_onNotificationsChanged);
    });
  }

  @override
  void dispose() {
    context.read<StoreOrderNotificationProvider>().removeListener(
      _onNotificationsChanged,
    );
    _bannerOverlay?.remove();
    super.dispose();
  }

  void _onNotificationsChanged() {
    if (!mounted) return;
    final provider = context.read<StoreOrderNotificationProvider>();
    final currentCount = provider.queueEntries.length;
    if (currentCount > _lastNotificationCount) {
      _showInAppBanner(provider.queueEntries.last);
    }
    _lastNotificationCount = currentCount;
  }

  void _showInAppBanner(QueueEntry entry) {
    _bannerOverlay?.remove();
    _bannerOverlay = OverlayEntry(
      builder: (_) => _InAppNotificationBanner(
        entry: entry,
        onDismiss: () {
          _bannerOverlay?.remove();
          _bannerOverlay = null;
        },
        onTap: () {
          _bannerOverlay?.remove();
          _bannerOverlay = null;
          final ctx = NavigationService.navigatorKey.currentContext;
          if (ctx != null) {
            Navigator.of(ctx).push(
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            );
          }
        },
      ),
    );
    Overlay.of(context).insert(_bannerOverlay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _getTabIndex(_selectedTab),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

// ─── In-app notification banner ───────────────────────────────────────────────

class _InAppNotificationBanner extends StatefulWidget {
  final QueueEntry entry;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const _InAppNotificationBanner({
    required this.entry,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  State<_InAppNotificationBanner> createState() =>
      _InAppNotificationBannerState();
}

class _InAppNotificationBannerState extends State<_InAppNotificationBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
    _autoHideTimer = Timer(const Duration(seconds: 4), _dismiss);
  }

  @override
  void dispose() {
    _autoHideTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Positioned(
      top: topPadding + 8,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          elevation: AppTheme.elevationL,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusM),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.notifications_active,
                    color: AppTheme.naturalWhite,
                    size: AppTheme.iconSizeL,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'New Order — Table ${widget.entry.tableNumber}',
                          style: const TextStyle(
                            color: AppTheme.naturalWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: AppTheme.bodyText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Queue #${widget.entry.queueNumber}  •  Party of ${widget.entry.partySize}',
                          style: const TextStyle(
                            color: AppTheme.naturalGrey,
                            fontSize: AppTheme.tinyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismiss,
                    child: const Icon(
                      Icons.close,
                      color: AppTheme.naturalWhite,
                      size: AppTheme.iconSizeM,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
