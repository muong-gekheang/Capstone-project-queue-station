import 'package:flutter/material.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';
import 'package:queue_station_app/ui/widgets/store_queue_history_card_widget.dart';

enum SortOption { oldest, newest }

SortOption? selectedSortOption;

class StoreQueueHistory extends StatefulWidget {
  final Restaurant restaurant;
  const StoreQueueHistory({super.key, required this.restaurant});

  @override
  State<StoreQueueHistory> createState() => _StoreQueueHistoryState();
}

class _StoreQueueHistoryState extends State<StoreQueueHistory> {
  late Restaurant restaurant;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;
  }

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<QueueEntry> getHistoriesForRestaurant(List<User> allUsers) {
    List<QueueEntry> filteredHistories = [];
    for (var user in allUsers) {
      if (user is Customer) {
        for (final historyId in user.historyIds) {
          final history = getHistoryById(historyId);
          if (history == null) continue;
          if (history.restId == restaurant.id) {
            filteredHistories.add(history);
          }
        }
      }
    }
    return filteredHistories;
  }

  Widget filteredQueueHistory() {
    final results = getHistoriesForRestaurant(mockUsers);
    final now = DateTime.now();

    final filteredResults = results.where((history) {
      final user = mockUsers.firstWhere((u) => u.id == history.customerId);
      final matchesSearch = user.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      if (!matchesSearch) return false;

      final joinTime = history.joinTime;

      if (selectedIndex == 0) return true;
      if (selectedIndex == 1) {
        return joinTime.year == now.year &&
            joinTime.month == now.month &&
            joinTime.day == now.day;
      }
      if (selectedIndex == 2) {
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        return joinTime.isAfter(sevenDaysAgo);
      }
      if (selectedIndex == 3) {
        return joinTime.year == now.year && joinTime.month == now.month;
      }
      return true;
    }).toList();

    if (selectedSortOption != null) {
      filteredResults.sort((a, b) {
        switch (selectedSortOption!) {
          case SortOption.oldest:
            return a.joinTime.compareTo(b.joinTime);
          case SortOption.newest:
            return b.joinTime.compareTo(a.joinTime);
        }
      });
    }

    return ListView.builder(
      itemCount: filteredResults.length,
      itemBuilder: (context, index) =>
          StoreQueueHistoryCard(queueEntry: filteredResults[index]),
    );
  }

  Widget buildTab(String title, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isSelected
                  ? AppTheme.secondaryColor
                  : AppTheme.naturalTextGrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            color: isSelected ? AppTheme.secondaryColor : Colors.transparent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Queue History',
        color: AppTheme.naturalBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(
                      hintText: "search...",
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<SortOption>(
                    hint: const Text("Sort by"),
                    value: selectedSortOption,
                    items: const [
                      DropdownMenuItem(
                        value: SortOption.oldest,
                        child: Text("Oldest"),
                      ),
                      DropdownMenuItem(
                        value: SortOption.newest,
                        child: Text("Newest"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSortOption = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildTab("All", 0),
                buildTab("Today", 1),
                buildTab("Last 7 Days", 2),
                buildTab("This Month", 3),
              ],
            ),
            Expanded(child: filteredQueueHistory()),
          ],
        ),
      ),
    );
  }
}
