import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/history.dart';
import 'package:queue_station_app/models/user/user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_list_view.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';
import 'package:queue_station_app/ui/screens/user_side/history/sort_button.dart';

enum SortType { recent, byMonth, byYear }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  SortType currentSortType = SortType.recent;
  List<History> historyList = [];

  @override
  void initState() {
    super.initState();
    User user = context.read<UserProvider>().currentUser!;
    List<History> sortedList = [...user.histories];
    sortedList.sort((a, b) => b.queue.joinTime.compareTo(a.queue.joinTime));
    historyList = sortedList;
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
    User user = userProvider.currentUser!;
    return CustomScreenView(
      title: "History",
      isTitleCenter: true,
      content: Column(
        spacing: 20,
        children: [
          SearchWidget<History>(
            filterLogic: (String search) {
              Set<History> filteredList = user.histories
                  .where(
                    (e) => e.rest.name.toLowerCase().startsWith(
                      search.toLowerCase(),
                    ),
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
