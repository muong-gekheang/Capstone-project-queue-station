import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/model/history.dart';
import 'package:queue_station_app/ui/widgets/half_clipper.dart';

class TicketWidget extends StatelessWidget {
  const TicketWidget({
    super.key,
    required this.topContent,
    required this.bottomContent,
  });

  final Column topContent;
  final Column bottomContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        spacing: 20,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 0),
            child: topContent,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerRight,
                widthFactor: 0.5,
                child: ClipRect(
                  clipper: HalfClipper(Side.right),
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
              Expanded(child: DottedLine(dashColor: Colors.white)),
              Align(
                alignment: Alignment.centerLeft,
                widthFactor: 0.5,
                child: ClipRect(
                  clipper: HalfClipper(Side.left),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 16.0),
            child: bottomContent,
          ),
        ],
      ),
    );
  }
}
