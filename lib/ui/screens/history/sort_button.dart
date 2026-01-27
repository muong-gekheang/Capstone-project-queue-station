import 'package:flutter/material.dart';
import 'package:queue_station_app/ui/screens/history/history_screen.dart';

class SortButton extends StatelessWidget {
  const SortButton({
    super.key,
    required this.label,
    required this.sortType,
    required this.currentSortType,
    required this.updateSort,
  });

  final String label;
  final SortType sortType;
  final SortType currentSortType;
  final ValueChanged<SortType> updateSort;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = sortType == currentSortType
        ? Theme.of(context).colorScheme.primary
        : Color(0xFFD4D8D6);

    Color textColor = sortType == currentSortType
        ? Theme.of(context).colorScheme.onPrimary
        : Color(0xFF6C6C6C);
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: backgroundColor),
      onPressed: () {
        updateSort(sortType);
      },
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
