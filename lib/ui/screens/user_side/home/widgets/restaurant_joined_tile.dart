import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart'; // for getHistoryById
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/ui/widgets/half_clipper.dart';

class RestaurantJoinedTile extends StatefulWidget {
  const RestaurantJoinedTile({super.key, required this.user});

  final Customer user;

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
    final currentHistory = getHistoryById(widget.user.currentHistoryId);
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
            color: Theme.of(context).colorScheme.secondary,
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
                      child: Image.asset(
                        "assets/home_screen/kungfu.png",
                        fit: BoxFit.fitHeight,
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
                          currentHistory?.queueNumber ?? "D025",
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
                        decoration: const BoxDecoration(
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
                        decoration: const BoxDecoration(
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
                      "Wait",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      currentHistory?.restId ?? "-",
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
