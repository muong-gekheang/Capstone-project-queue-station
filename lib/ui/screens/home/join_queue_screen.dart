import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:queue_station_app/model/restaurant.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';

class JoinQueueScreen extends StatefulWidget {
  const JoinQueueScreen({super.key, required this.rest});

  final Restaurant rest;

  @override
  State<JoinQueueScreen> createState() => _JoinQueueScreenState();
}

class _JoinQueueScreenState extends State<JoinQueueScreen> {
  int numPeople = 0;

  void onTableTap(int value) {
    setState(() {
      numPeople = value;
    });
  }

  void increPeople() {
    setState(() {
      numPeople = min(numPeople + 1, widget.rest.biggestTableSize);
    });
  }

  void decrePeople() {
    setState(() {
      numPeople = max(numPeople - 1, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedPhone = widget.rest.phone.length >= 6
        ? widget.rest.phone.replaceAllMapped(RegExp(r"(\d{3})(\d{3})(\d+)"), (
            match,
          ) {
            return "${match[1]} ${match[2]} ${match[3]}";
          })
        : "";

    return CustomScreenView(
      content: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((255 * 0.25).toInt()),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    SizedBox.square(
                      dimension: 160,
                      child: Image.asset(
                        "assets/home_screen/kungfu.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.rest.name,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFFF6835),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                              Icon(Icons.location_pin),
                              Expanded(
                                child: Text(
                                  widget.rest.address,
                                  softWrap: true,
                                  style: TextStyle(
                                    color: Color(0xFF0D47A1),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.rest.policy.isNotEmpty)
                  const Text(
                    "Restaurant Policy",
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                if (widget.rest.policy.isNotEmpty)
                  Text(
                    widget.rest.policy,
                    style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                  ),
                const Text(
                  "Our Biggest Table Size",
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${widget.rest.biggestTableSize.toString()} people per table",
                  style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                ),
                const Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Color(0xFF0D47A1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  formattedPhone,
                  style: TextStyle(fontSize: 16, color: Color(0xFFFF6835)),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ListTile(
            tileColor: Color(0xFFFF6835),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
            title: Text(
              "Wait",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              "Estimated waiting time: ${widget.rest.averageWaitingTime.inMinutes} min",
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.rest.curWait.toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Entries",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          const Text(
            "Queue Type",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TableTypeWidget(
                selectedType: numPeople,
                value: 1,
                onTap: onTableTap,
              ),
              TableTypeWidget(
                selectedType: numPeople,
                value: 2,
                onTap: onTableTap,
              ),
              TableTypeWidget(
                selectedType: numPeople,
                value: 3,
                onTap: onTableTap,
              ),
              TableTypeWidget(
                selectedType: numPeople,
                value: 4,
                onTap: onTableTap,
              ),
            ],
          ),
          SizedBox(height: 16),
          const Text("Number of Guest(s)", style: TextStyle(fontSize: 16)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 19,
            children: [
              IconButton(
                onPressed: numPeople == 0 ? null : decrePeople,
                color: Colors.white,
                disabledColor: Colors.white,
                style: IconButton.styleFrom(
                  backgroundColor: Color(0xFFFF6835),
                  disabledBackgroundColor: Color(0xFFD4D8D6),
                ),
                icon: const Icon(Icons.remove),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF73706E), width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      NumberFormat("00").format(numPeople),
                      style: TextStyle(
                        letterSpacing: 10,
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                        height: 1.0,
                      ),
                    ),
                    Positioned.fill(
                      child: VerticalDivider(
                        color: Color(0xFF73706E),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: increPeople,
                color: Colors.white,
                style: IconButton.styleFrom(backgroundColor: Color(0xFFFF6835)),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFFFF6835),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(0),
          ),
        ),
        child: const Text("Join Queue", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class TableTypeWidget extends StatelessWidget {
  const TableTypeWidget({
    super.key,
    required this.value,
    required this.selectedType,
    required this.onTap,
  });

  final int value;
  final int selectedType;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == selectedType;
    Color boxColor = isSelected ? Color(0xFFFF6835) : Color(0xFF0D47A1);
    String tableText = value > 1 ? "$value People" : "$value Person";
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? boxColor : Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Column(
          children: [
            Icon(Symbols.dine_lamp, color: boxColor, size: 30),
            Text(
              tableText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: boxColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
