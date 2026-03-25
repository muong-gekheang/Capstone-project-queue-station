import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/history/widgets/history_list_view.dart';
import 'package:queue_station_app/ui/screens/user_side/history/widgets/sort_button.dart';
import 'package:queue_station_app/ui/screens/user_side/history/view_models/history_view_model.dart';
import 'package:queue_station_app/ui/widgets/custom_screen_view.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';

enum SortType { recent, byMonth, byYear }

class HistoryContent extends StatefulWidget {
  const HistoryContent({ super.key});

  @override
  State<HistoryContent> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryContent> {
  SortType currentSortType = SortType.recent;

  void updateSort(SortType newSortType) {
    if (currentSortType != newSortType) {
      setState(() {
        currentSortType = newSortType;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyVM = context.watch<HistoryViewModel>();

    if (historyVM.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final historyList = historyVM.history;

    return CustomScreenView(
      title: "History",
      isTitleCenter: true,
      content: Column(
        spacing: 20,
        children: [
          SearchWidget<QueueEntry>(
            filterLogic: (String search) {
              return historyList
                  .where(
                    (e) =>
                        historyVM
                            .getRestaurant(e.restId)
                            ?.name
                            .toLowerCase()
                            .startsWith(search.toLowerCase()) ??
                        false,
                  )
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: HistoryCard(
                        history: e,
                        restaurant: historyVM.getRestaurant(e.restId)!,
                      ),
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
