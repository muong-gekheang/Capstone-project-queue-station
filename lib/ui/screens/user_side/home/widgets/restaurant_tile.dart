import 'package:flutter/material.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/join_queue_screen.dart';

class RestaurantTile extends StatefulWidget {
  const RestaurantTile({super.key, required this.rest});

  final Restaurant rest;

  @override
  State<RestaurantTile> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantTile> {
  bool _isPressed = false;
  Future<void> onRestTap(Restaurant rest) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return JoinQueueScreen(rest: widget.rest);
        },
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
            offset: Offset(0, 0),
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
        onTap: () => onRestTap(widget.rest),
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
                    "assets/home_screen/burger-logo.jpg",
                    fit: BoxFit.cover
                  )
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rest.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_pin),
                          Text(widget.rest.address),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.hourglass_empty, color: Color(0xFFFF6835)),
                          Text(
                            "${10} people waiting",
                            style: TextStyle(color: Color(0xFFFF6835)),
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
