import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
