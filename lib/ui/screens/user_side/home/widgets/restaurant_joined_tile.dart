import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/widgets/half_clipper.dart';

class RestaurantJoinedTile extends StatefulWidget {
  const RestaurantJoinedTile({
    super.key,
    required this.queueEntry,
    required this.restaurant,
    this.peopleWaiting,
  });

  final QueueEntry queueEntry;
  final Restaurant restaurant;
  final int? peopleWaiting;

  @override
  State<RestaurantJoinedTile> createState() => _RestaurantJoinedTileState();
}

class _RestaurantJoinedTileState extends State<RestaurantJoinedTile> {
  bool _isPressed = false;

  Future<void> onPress() async {
    context.go("/ticket");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      onTap: onPress,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 10),
        opacity: _isPressed ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: widget.peopleWaiting == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    SizedBox.square(
                      dimension: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: Image.network(
                          widget.restaurant.logoLink,
                          fit: BoxFit.cover,

                          errorBuilder: (context, error, stackTrace) {
                            // fallback if image fails to load
                            return Icon(
                              Icons.restaurant,
                              size: 50,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),

                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Your Queue Number",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          widget.queueEntry.queueNumber,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 0.5,
                    heightFactor: 0,
                    child: ClipRect(
                      clipper: HalfClipper(Side.bottom),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                  DottedLine(
                    direction: Axis.vertical,
                    lineLength: 100,
                    dashColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    widthFactor: 0.5,
                    heightFactor: 0,

                    child: ClipRect(
                      clipper: HalfClipper(Side.top),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.peopleWaiting != 0
                          ? "Wait"
                          : "Please Check In at store",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    if (widget.peopleWaiting != 0)
                      Text(
                        widget.peopleWaiting.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
