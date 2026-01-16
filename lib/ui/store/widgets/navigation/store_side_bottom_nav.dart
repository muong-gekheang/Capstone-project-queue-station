import 'package:flutter/material.dart';
import '../../../../core/constants/enums.dart';

class BottomNavBar extends StatelessWidget {
  final NavTab selectedTab;
  final Function(NavTab) onTabSelected;

  const BottomNavBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                NavTab.dashboard,
                Icons.dashboard_outlined,
                Icons.dashboard,
                'Dashboard',
              ),
              _buildNavItem(
                NavTab.analytics,
                Icons.storefront_outlined,
                Icons.storefront,
                'Manage',
              ),
              _buildNavItem(
                NavTab.settings,
                Icons.settings_outlined,
                Icons.settings,
                'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavTab tab,
    IconData iconOutlined,
    IconData iconFilled,
    String label,
  ) {
    final isSelected = selectedTab == tab;
    
    return GestureDetector(
      onTap: () => onTabSelected(tab),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconFilled : iconOutlined,
              color: isSelected ? const Color(0xFFEF4444) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFEF4444) : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}