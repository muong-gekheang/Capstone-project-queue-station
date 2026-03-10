import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/ui/screens/store_side/store_queue_history/view_model/store_queue_history_view_model.dart';
import 'package:queue_station_app/ui/theme/app_theme.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';
import 'package:queue_station_app/ui/widgets/store_queue_history_card_widget.dart';

class StoreQueueHistoryContent extends StatelessWidget {
  final Restaurant restaurant;
  const StoreQueueHistoryContent({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // Use select or watch to listen to the ViewModel
    final vm = context.watch<StoreQueueHistoryViewModel>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Queue History',
        color: AppTheme.naturalBlack,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            _buildHeader(context, vm),
            const SizedBox(height: 10),
            _buildTabs(vm),
            Expanded(child: _buildHistoryList(vm)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StoreQueueHistoryViewModel vm) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: SearchbarWidget(
              hintText: "search...",
              onChanged: (value) => vm.setSearchQuery(value),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButton<SortOption>(
            hint: const Text("Sort by"),
            value: vm.selectedSortOption,
            items: const [
              DropdownMenuItem(value: SortOption.oldest, child: Text("Oldest")),
              DropdownMenuItem(value: SortOption.newest, child: Text("Newest")),
            ],
            onChanged: (value) => vm.setSortOption(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(StoreQueueHistoryViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _tabItem("All", 0, vm),
        _tabItem("Today", 1, vm),
        _tabItem("Last 7 Days", 2, vm),
        _tabItem("This Month", 3, vm),
      ],
    );
  }

  Widget _tabItem(String title, int index, StoreQueueHistoryViewModel vm) {
    final isSelected = vm.selectedIndex == index;
    return GestureDetector(
      onTap: () => vm.setSelectedIndex(index),
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

  Widget _buildHistoryList(StoreQueueHistoryViewModel vm) {
    final filteredResults = vm.getFilteredHistory();

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 200) {
          vm.loadMore();
        }
        return true;
      },
      child: ListView.builder(
        // Add one extra item for the loading indicator if we are fetching
        itemCount: filteredResults.length + (vm.isFetching ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < filteredResults.length) {
            return StoreQueueHistoryCard(queueEntry: filteredResults[index]);
          } else {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: vm.hasMoreData
                  ? Center(child: CircularProgressIndicator())
                  : Text("There is no more history."),
            );
          }
        },
      ),
    );
  }
}
