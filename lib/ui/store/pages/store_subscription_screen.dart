import 'package:flutter/material.dart';
import '../widgets/navigation/store_side_bottom_nav.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/navigation/store_side_nav_router.dart';

class StoreSubscriptionScreen extends StatelessWidget {
  const StoreSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "My subscription",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSubscriptionRow("Current Plan", "Standard"),
                const Divider(height: 32),
                _buildSubscriptionRow("Start Date", "10/Dec/2025"),
                const Divider(height: 32),
                _buildSubscriptionRow("Renewable Date", "10/Dec - monthly"),
                const Divider(height: 32),
                _buildSubscriptionRow("Price", "\$40"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedTab: NavTab.settings,
        onTabSelected: (tab) {
          if (tab == NavTab.settings) return;
          NavRouter.handleTabSelection(context, tab);
        },
      ),
    );
  }

  Widget _buildSubscriptionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF6835),
          ),
        ),
      ],
    );
  }
}
