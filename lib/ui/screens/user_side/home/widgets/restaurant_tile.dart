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
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onRestTap(widget.rest),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.25).toInt()),
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.rest.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                      "${widget.rest.curWait} people waiting",
                      style: TextStyle(color: Color(0xFFFF6835)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
