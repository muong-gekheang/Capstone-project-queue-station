import 'package:flutter/material.dart';
import 'package:queue_station_app/data/mock_table_data.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/table_management_screen.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/menu_management.dart';
import 'package:queue_station_app/ui/screens/store_side/store_management/store_queue_history.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../model/services/store_profile_service.dart';
import 'analytics_screen.dart';

class ManageStorePage extends StatefulWidget {
  const ManageStorePage({super.key});

  @override
  State<ManageStorePage> createState() => _ManageStorePageState();
}

class _ManageStorePageState extends State<ManageStorePage> {
  late final StoreProfileService _storeService;

  @override
  void initState() {
    super.initState();
    _storeService = StoreProfileService();
    _storeService.addListener(_onProfileChanged);
  }

  @override
  void dispose() {
    _storeService.removeListener(_onProfileChanged);
    super.dispose();
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  bool isStoreOpen = true;

  void _showCloseStoreDialog() {
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
                      setState(() => isStoreOpen = false);
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
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
        // Store Profile Image - display only (set in settings)
        _buildStoreProfileImage(),
        // Notification Icon - toggleable
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.black),
              // Optional: Add notification badge
              // Positioned(
              //   right: 0,
              //   top: 0,
              //   child: Container(
              //     width: 8,
              //     height: 8,
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       shape: BoxShape.circle,
              //     ),
              //   ),
              // ),
            ],
          ),
          onPressed: () {
            // Toggle notifications or navigate to notifications page
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoreStatus(),
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
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildPrimaryButton(),
        ],
      ),
    );
  }

  Widget _buildStoreStatus() {
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
                  color: isStoreOpen ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isStoreOpen ? 'Open' : 'Closed',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Switch(
            value: isStoreOpen,
            activeColor: const Color(0xFF0D47A1),
            onChanged: (value) {
              if (value == false) {
                // Show warning dialog when trying to close store
                _showCloseStoreDialog();
              } else {
                // Opening store doesn't need confirmation
                setState(() => isStoreOpen = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TableManagementScreen(tableCategory: tableData),
              ),
            );
          },
        ),
        _SvgActionCard(
          'assets/icons/Manage_menu.svg',
          'Manage\nMenu',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuManagement()),
            );
          },
        ),
        _SvgActionCard(
          'assets/icons/Queue_history.svg',
          'Queue\nhistory',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreQueueHistory()),
            );
          },
        ),
        _SvgActionCard(
          'assets/icons/Analytics_blue.svg',
          'Analytics',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
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
          // Navigate to manage queue page
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

  // Placeholder for store profile image widget
  Widget _buildStoreProfileImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }
}

// Moved outside the state class
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

  const _ActionCard(this.icon, this.label, this.iconColor, {this.onTap});

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
