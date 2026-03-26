import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/services/order_service.dart';
import 'package:queue_station_app/services/queue_service.dart';
import 'package:queue_station_app/services/store/restaurant_service.dart';
import 'package:queue_station_app/ui/screens/notification/notification_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/queue/store_queue_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/manage_store/view_model/manage_store_view_model.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/manage_store/view_model/manage_store_navigation_view_model.dart';

class ManageStoreContent extends StatefulWidget {
  const ManageStoreContent({super.key, required this.onManageQueue});
  final VoidCallback onManageQueue;
  @override
  State<ManageStoreContent> createState() => _ManageStoreContentState();
}

class _ManageStoreContentState extends State<ManageStoreContent> {

  @override
  void initState() {
    super.initState();
  }

  void _showCloseStoreDialog() {
    ManageStoreViewModel manageStoreViewModel = context
        .read<ManageStoreViewModel>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Are you sure?',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: const Text(
            'Close store now? Customers won\'t see it until you reopen.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'No, Don\'t',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF3B30),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      manageStoreViewModel.updateStoreStatus(false);
                    },
                    child: const Text(
                      'Yes, Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ManageStoreViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/Store_Management_blue.svg',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'Manage',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        buildStoreProfileImage(),
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
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildStoreStatus(),
          const SizedBox(height: 24),
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          buildQuickActions(),
          const SizedBox(height: 24),
          buildPrimaryButton(),
        ],
      ),
    );
  }

  Widget buildStoreStatus() {
    ManageStoreViewModel manageStoreViewModel = context
        .read<ManageStoreViewModel>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Store Status:',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: manageStoreViewModel.isStoreOpen
                      ? Colors.green
                      : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                manageStoreViewModel.isStoreOpen ? 'Open' : 'Closed',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          manageStoreViewModel.isLoading
              ? CircularProgressIndicator()
              : Switch(
                  value: manageStoreViewModel.isStoreOpen,
                  activeThumbColor: const Color(0xFF0D47A1),
                  onChanged: (value) {
                    if (value == false) {
                      // Show warning dialog when trying to close store
                      _showCloseStoreDialog();
                    } else {
                      manageStoreViewModel.updateStoreStatus(true);
                    }
                  },
                ),
        ],
      ),
    );
  }

  Widget buildQuickActions() {
    late ManageStoreNavigationViewModel navigationViewModel;
    
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.1,
      children: [
        _SvgActionCard(
          'assets/icons/Manage_table.svg',
          'Manage\nTable',
          onTap: () {
            navigationViewModel = ManageStoreNavigationViewModel(context: context);
            navigationViewModel.navigateToTableManagement();
          },
        ),
        _SvgActionCard(
          'assets/icons/Manage_menu.svg',
          'Manage\nMenu',
          onTap: () {
            navigationViewModel = ManageStoreNavigationViewModel(context: context);
            navigationViewModel.navigateToMenuManagement();
          },
        ),
        _SvgActionCard(
          'assets/icons/Queue_history.svg',
          'Queue\nhistory',
          onTap: () {
            navigationViewModel = ManageStoreNavigationViewModel(context: context);
            navigationViewModel.navigateToQueueHistory();
          },
        ),
        _SvgActionCard(
          'assets/icons/Analytics_blue.svg',
          'Analytics',
          onTap: () {
            navigationViewModel = ManageStoreNavigationViewModel(context: context);
            navigationViewModel.navigateToAnalytics();
          },
        ),
      ],
    );
  }

  Widget buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: () {
          final restaurantService = context.read<RestaurantService>();
          final queueService = context.read<QueueService>();
          Navigator.push(
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
        child: const Text(
          'Manage Queue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildStoreProfileImage() {
    final manageStoreViewModel = context.read<ManageStoreViewModel>();
    final storeName = manageStoreViewModel.storeName;
    final storeLogo = manageStoreViewModel.storeLogo;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFFF6835).withValues(alpha: 0.1),
        backgroundImage: storeLogo.isNotEmpty 
            ? NetworkImage(storeLogo)
            : null,
        child: storeLogo.isEmpty
            ? Text(
                storeName.isNotEmpty ? storeName[0].toUpperCase() : 'S',
                style: const TextStyle(
                  color: Color(0xFFFF6835),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              )
            : null,
      ),
    );
  }
}

class _SvgActionCard extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback? onTap;
  const _SvgActionCard(this.svgAsset, this.label, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgAsset, width: 40, height: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final VoidCallback? onTap;

  const _ActionCard(this.icon, this.label, this.iconColor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}