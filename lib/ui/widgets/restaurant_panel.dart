import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';

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
                          restaurant.curWait.toString().padLeft(2, '0'),
                          "Wait in queue",
                          color: restaurant.curWait >= 20
                              ? Colors.red
                              : restaurant.curWait >= 10
                              ? Colors.amber.shade600
                              : Colors.green,
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
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
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
              height: 180, // Height of the horizontal scroll area
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: restaurant.menuImageLinks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // Optional: Open image in full screen if tapped
                        _showFullScreenImage(
                          context,
                          restaurant.menuImageLinks[index],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          restaurant.menuImageLinks[index],
                          width: 140,
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

  // --- OPTIONAL: Simple Full Screen Image Viewer ---
  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
