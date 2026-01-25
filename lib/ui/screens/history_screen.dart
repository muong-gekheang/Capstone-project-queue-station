import 'package:flutter/material.dart';
import 'package:queue_station_app/model/restaurant.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/home_screen.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';

enum SortType { Recent, ByMonth, ByYear }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  SortType currentSortType = SortType.Recent;

  void updateSort(SortType newSortType) {
    if (currentSortType != newSortType) {
      setState(() {
        currentSortType = newSortType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 10,
        children: [
          SearchWidget<Restaurant>(
            filterLogic: (String search) {
              Set<Restaurant> filteredList = mockData
                  .where(
                    (e) =>
                        e.name.toLowerCase().startsWith(search.toLowerCase()),
                  )
                  .toSet();
              return filteredList.map((e) => RestaurantCard(rest: e)).toList();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SortButton(
                label: "Recent",
                currentSortType: currentSortType,
                sortType: SortType.Recent,
                updateSort: updateSort,
              ),
              SortButton(
                label: "Sort by month",
                currentSortType: currentSortType,
                sortType: SortType.ByMonth,
                updateSort: updateSort,
              ),
              SortButton(
                label: "Sort by year",
                currentSortType: currentSortType,
                sortType: SortType.ByYear,
                updateSort: updateSort,
              ),
            ],
          ),
          // Expanded(child: ListView.separated(,itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount))
        ],
      ),
    );
  }
}

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

void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text("History"), centerTitle: true),
        body: SafeArea(child: HistoryScreen()),
      ),
    ),
  );
}
