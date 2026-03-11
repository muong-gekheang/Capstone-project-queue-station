import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestsCounterWidget extends StatelessWidget {
  final int numPeople;
  final VoidCallback incrPeople;
  final VoidCallback decrPeople;
  const GuestsCounterWidget({super.key, required this.numPeople, required this.incrPeople, required this.decrPeople});

  @override
  Widget build(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 19,
            children: [
              IconButton(
                onPressed: numPeople == 0 ? null : decrPeople,
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
                    const Positioned.fill(
                      child: VerticalDivider(
                        color: Color(0xFF73706E),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: incrPeople,
                color: Colors.white,
                style: IconButton.styleFrom(backgroundColor: Color(0xFFFF6835)),
                icon: const Icon(Icons.add),
              ),
            ],
          );
  }
}
