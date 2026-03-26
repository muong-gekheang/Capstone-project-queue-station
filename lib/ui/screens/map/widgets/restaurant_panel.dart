import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/services/queue_service.dart';

class RestaurantPanel extends StatelessWidget {
  final Restaurant restaurant;
  final bool isOwner;
  final VoidCallback onClearSelection;
  final VoidCallback onDrawRoute;
  final VoidCallback onContactTap;
  final VoidCallback onDeleteLocation;
  final VoidCallback onEditLocation;
  final VoidCallback onShareTap;
  final VoidCallback onEditMenuTap;
  final int currentWait;

  const RestaurantPanel({
    super.key,
    required this.restaurant,
    required this.isOwner,
    required this.onClearSelection,
    required this.onDrawRoute,
    required this.onContactTap,
    required this.onDeleteLocation,
    required this.onEditLocation,
    required this.onShareTap,
    required this.onEditMenuTap,
    required this.currentWait,
    // required this.queueInWait,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  restaurant.logoLink,
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStat(
                          // restaurant.curWait.toString().padLeft(2, '0'),
                          currentWait.toString(),
                          "Wait in queue",
                          color: currentWait >= 20
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
                        //   "Queue",
                        //   color: const Color(0xFF0D47A1),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClearSelection,
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Open: ${_formatMinutesToTime(restaurant.openingTime)} - ${_formatMinutesToTime(restaurant.closingTime)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: restaurant.isCurrentlyOpen
                            ? const Color(0xFF10B981)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                    Text(
                      restaurant.isCurrentlyOpen ? "Open Now" : "Closed",
                      style: TextStyle(
                        color: restaurant.isCurrentlyOpen
                            ? const Color(0xFF10B981)
                            : const Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // --- NEW: Dynamic Button based on Owner Status ---
              isOwner
                  ? ElevatedButton.icon(
                      onPressed: onDeleteLocation,
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text("Remove Marker"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6835),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Join Queue"),
                    ),
            ],
          ),
          const Divider(height: 40, thickness: 2, color: Color(0xFF0D47A1)),
          const Text(
            "Overview",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0D47A1), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // --- NEW: Change "Directions" to "Edit Location" for owners ---
                isOwner
                    ? GestureDetector(
                        onTap: onEditLocation,
                        child: _buildIconAction(
                          Icons.edit_location_alt,
                          "Edit Loc",
                        ),
                      )
                    : GestureDetector(
                        onTap: onDrawRoute,
                        child: _buildIconAction(
                          Icons.near_me_rounded,
                          "Direction",
                        ),
                      ),
                GestureDetector(
                  onTap: onContactTap,
                  child: _buildIconAction(Icons.phone, "Contact"),
                ),
                GestureDetector(
                  onTap: onShareTap, // <-- ATTACH IT HERE
                  child: _buildIconAction(Icons.share, "Share"),
                ),
              ],
            ),
          ),

          // --- NEW: MENU IMAGES SECTION ---
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Menu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              // --- NEW: Edit Menu button for Owner ---
              if (isOwner)
                TextButton.icon(
                  onPressed: onEditMenuTap,
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                    color: Color(0xFFFF6835),
                  ),
                  label: const Text(
                    "Edit Images",
                    style: TextStyle(
                      color: Color(0xFFFF6835),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (restaurant.menuImageLinks.isNotEmpty)
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: restaurant.menuImageLinks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        _showFullScreenImage(
                          context,
                          restaurant.menuImageLinks[index],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          restaurant.menuImageLinks[index],
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 140,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Image Error",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            // Empty State Placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.grey, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "No menu images available",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }

  // Helper widget builder for stats
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

  // Helper widget builder for action icons
  Widget _buildIconAction(IconData icon, String label) => Column(
    children: [
      CircleAvatar(
        backgroundColor: const Color(0xFF0D47A1),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ],
  );

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.7),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                minScale: 0.5,
                maxScale: 4.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 60,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: constraints.maxWidth,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black45,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to convert minutes (e.g. 510) to "8:30 AM" format
  String _formatMinutesToTime(int totalMinutes) {
    if (totalMinutes == 0) return "12:00 AM";

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    String amPm = hours >= 12 ? "PM" : "AM";

    // Convert 24h to 12h format
    int displayHours = hours % 12;
    if (displayHours == 0) displayHours = 12;

    String minString = minutes.toString().padLeft(2, '0');

    return "$displayHours:$minString $amPm";
  }
}
