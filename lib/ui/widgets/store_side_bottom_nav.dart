
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:queue_station_app/ui/store_main_screen.dart';

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
                'assets/icons/Dashboard.svg',
                'assets/icons/Dashboard_orange.svg',
                null,
                'Dashboard',
              ),
              _buildNavItem(
                NavTab.analytics,
                'assets/icons/Store_Management.svg',
                'assets/icons/Store_Management_orange.svg',
                null,
                'Manage',
              ),
              _buildNavItem(
                NavTab.settings,
                'assets/icons/Setting.svg',
                'assets/icons/Setting_orange.svg',
                null,
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
    String iconAsset,
    String iconAssetOrange,
    String? iconAssetBlue,
    String label,
  ) {
    final isSelected = selectedTab == tab;
    String assetToUse = isSelected ? iconAssetOrange : iconAsset;
    Color? iconColor = isSelected ? null : Colors.black;
    return GestureDetector(
      onTap: () => onTabSelected(tab),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSvgOrIcon(assetToUse, iconColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFF6835) : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSvgOrIcon(String assetPath, Color? color) {
    // Try to load SVG, fallback to a default icon if it fails
    return SvgPicture.asset(
      assetPath,
      width: 26,
      height: 26,
      color: color,
      placeholderBuilder: (context) => Icon(Icons.circle, size: 26, color: Colors.grey),
    );
  }
}
