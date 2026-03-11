import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/customer.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_list_view.dart';
import 'package:queue_station_app/ui/screens/user_side/history/sort_button.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';

enum SortType { recent, byMonth, byYear }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  SortType currentSortType = SortType.recent;
  List<QueueEntry> historyList = [];

  @override
  void initState() {
    super.initState();
    Customer? user = context.read<UserProvider>().asCustomer;
    if (user != null) {
      List<QueueEntry> sortedList = user.historyIds
          .map((e) => {})
          .whereType<QueueEntry>()
          .toList();
      sortedList.sort((a, b) => b.joinTime.compareTo(a.joinTime));
      historyList = sortedList;
    }
  }

  void updateSort(SortType newSortType) {
    if (currentSortType != newSortType) {
      setState(() {
        currentSortType = newSortType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    Customer? user = userProvider.asCustomer;
    return CustomScreenView(
      title: "History",
      isTitleCenter: true,
      content: Column(
        spacing: 20,
        children: [
          SearchWidget<QueueEntry>(
            filterLogic: (String search) {
              // TODO: Use Repos in VM to fetch and create Rest obj
              Set<QueueEntry> filteredList = (user?.historyIds ?? [])
                  .map((e) => {})
                  .whereType<QueueEntry>()
                  .where(
                    (e) =>
                        e.restId.toLowerCase().startsWith(search.toLowerCase()),
                  )
                  .toSet();
              return filteredList
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: HistoryCard(history: e),
                    ),
                  )
                  .toList();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SortButton(
                label: "Recent",
                currentSortType: currentSortType,
                sortType: SortType.recent,
                updateSort: updateSort,
              ),
              SortButton(
                label: "Sort by month",
                currentSortType: currentSortType,
                sortType: SortType.byMonth,
                updateSort: updateSort,
              ),
              SortButton(
                label: "Sort by year",
                currentSortType: currentSortType,
                sortType: SortType.byYear,
                updateSort: updateSort,
              ),
            ],
          ),
          HistoryListView(
            historyList: historyList,
            currentSortType: currentSortType,
          ),
        ],
      ),
    );
  }
}
