import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/join_queue_screen.dart';

class RestaurantTile extends StatefulWidget {
  const RestaurantTile({super.key, required this.rest});

  final Restaurant rest;

  @override
  State<RestaurantTile> createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  bool _isPressed = false;

  Future<void> onRestTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinQueueScreen(rest: widget.rest),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        onTap: onRestTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 10),
          opacity: _isPressed ? 0.6 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              spacing: 10,
              children: [
                SizedBox.square(
                  dimension: 75,
                  child: Image.asset(
                    "assets/home_screen/kungfu.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rest.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_pin),
                          Text(widget.rest.address),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.hourglass_empty,
                            color: Color(0xFFFF6835),
                          ),
                          Text(
                            // Replace curWait with a proper field; here using a placeholder
                            "? people waiting",
                            style: const TextStyle(color: Color(0xFFFF6835)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
