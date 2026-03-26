import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

class RoutePreviewPanel extends StatelessWidget {
  final Restaurant restaurant;
  final String distance;
  final VoidCallback onClose;
  final VoidCallback onNavigation;
  final int currentWait;

  const RoutePreviewPanel({
    super.key,
    required this.restaurant,
    required this.distance,
    required this.onClose,
    required this.onNavigation,
    required this.currentWait,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  restaurant.logoLink,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 100,
                    width: 100,
                    color: const Color(0xFF0D47A1),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Right side stats & buttons
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: onNavigation,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFF0D47A1),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 10,
                              child: Icon(
                                Icons.near_me_outlined,
                                color: const Color(0xFFFF6835),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 100),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6835),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(100, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Join Queue",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Close Button
                        GestureDetector(
                          onTap: onClose,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D47A1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Color(0xFFFF6835),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Queue Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(
                          // restaurant.curWait.toString().padLeft(2, '0'),
                          currentWait.toString().padLeft(2, '0'),
                          "Wait in queue",
                          color: restaurant.curWait >= 20
                              ? Color(0xFFDC2626)
                              : restaurant.curWait >= 10
                              ? Color(0xFFF97316)
                              : Color(0xFF10B981),
                        ),
                        // Container(
                        //   width: 1,
                        //   height: 30,
                        //   color: Colors.grey.shade300,
                        // ),
                        // _buildStat(
                        //   restaurant.curWait.toString(),
                        //   "Current queue",
                        //   color: const Color(0xFF0D47A1),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // From / To Section
          const Text(
            "From: Your location",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  "To: ${restaurant.name}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                distance,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: distance == "Calculating..." ? 13 : 16,
                  color: distance == "Calculating..."
                      ? Colors.grey
                      : const Color(0xFFFF6835),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStat(
    String val,
    String label, {
    Color color = const Color(0xFFFF6835),
  }) => Column(
    children: [
      Text(
        val,
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
