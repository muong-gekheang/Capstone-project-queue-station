import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:queue_station_app/ui/normal_user_app.dart';

class NormalUserButtomNav extends StatelessWidget {
  final NormalUserNavTab selectedTab;
  final Function(NormalUserNavTab) onTabSelected;

  const NormalUserButtomNav({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  Widget _buildNavItem(NormalUserNavTab tab, String icon, {String? label}) {
    final isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () => onTabSelected(tab),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter:  ColorFilter.mode(isSelected ? const Color(0xFFFF6835) : Colors.grey , BlendMode.srcIn),
              width: 35,
              height: 35,
            ),
            const SizedBox(height: 4),
            if(label != null)
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              NormalUserNavTab.home, 
              'assets/images/home_icon.svg',
            ),
            _buildNavItem(
              NormalUserNavTab.map, 
              'assets/images/map_icon.svg', 
            ),
            _buildNavItem(
              NormalUserNavTab.ticket,
              'assets/images/ticket_confirmation.svg',
            ),
            _buildNavItem(
              NormalUserNavTab.foodOrdering, 
              'assets/images/food_ordering_icon.svg'
            ),
            _buildNavItem(
              NormalUserNavTab.profile, 
              'assets/images/profile_icon.svg'
              ),
          ],
        ),
      ),
    );
  }
}


