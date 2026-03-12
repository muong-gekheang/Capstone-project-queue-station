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
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 0,
          ), // No horizontal padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(
                NavTab.dashboard,
                'assets/icons/Dashboard.svg',
                'Dashboard',
                4,
              ),
              _buildNavItem(
                NavTab.analytics,
                'assets/icons/Store_Management.svg',
                'Manage',
                3,
              ),
              _buildNavItem(
                NavTab.queue,
                'assets/icons/queue_blue.svg',
                'Queue',
                3,
              ),
              _buildNavItem(
                NavTab.settings,
                'assets/icons/Setting.svg',
                'Settings',
                4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(NavTab tab, String iconAsset, String label, int flex) {
    final isSelected = selectedTab == tab;

    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => onTabSelected(tab),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 60,
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SizedBox(
                width: 26,
                height: 26,
                child: SvgPicture.asset(
                  iconAsset,
                  width: 26,
                  height: 26,
                  fit: BoxFit.contain,
                  allowDrawingOutsideViewBox: false,
                  colorFilter: ColorFilter.mode(
                    isSelected ? const Color(0xFFFF6835) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 4),
              // Text with no extra width constraints
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFF6835) : Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
