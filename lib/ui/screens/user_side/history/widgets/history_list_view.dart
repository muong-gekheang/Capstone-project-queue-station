import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/queue_entry.dart';
import 'package:queue_station_app/ui/screens/user_side/history/widgets/history_view_screen.dart';
import 'package:queue_station_app/ui/screens/user_side/history/view_models/history_view_model.dart';
import 'package:queue_station_app/ui/screens/user_side/history/widgets/history_content.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key,
    required this.historyList,
    required this.currentSortType,
  });

  final List<QueueEntry> historyList;
  final SortType currentSortType;

  @override
  Widget build(BuildContext context) {
    final historyVM = context.watch<HistoryViewModel>();

    String? lastGroup;
    String? currentGroup;
    String dateDisplayFormat = currentSortType == SortType.byMonth
        ? "MMM yyyy"
        : "yyyy";

    List<Widget> widgetList = [];

    for (var h in historyList) {
      if (currentSortType != SortType.recent) {
        currentGroup = DateFormat(dateDisplayFormat).format(h.joinTime);
        if (currentGroup != lastGroup) {
          widgetList.add(HistoryTitle(currentGroup: currentGroup));
          lastGroup = currentGroup;
        }
      }

      final restaurant = historyVM.getRestaurant(h.restId);
      if (restaurant != null) {
        widgetList.add(HistoryCard(history: h, restaurant: restaurant));
      }
    }

    return Expanded(
      child: ListView.separated(
        itemCount: widgetList.length,
        itemBuilder: (context, index) => widgetList[index],
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}

class HistoryTitle extends StatelessWidget {
  const HistoryTitle({super.key, required this.currentGroup});

  final String currentGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        currentGroup,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class HistoryCard extends StatefulWidget {
  const HistoryCard({
    super.key,
    required this.history,
    required this.restaurant,
  });
  final QueueEntry history;
  final Restaurant restaurant;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  Future<void> onHistoryTab(QueueEntry history) async {
    final historyVM = context.read<HistoryViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: historyVM,
          child: HistoryViewScreen(history: history),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String guestSuffix = widget.history.partySize > 1 ? "People" : "Person";
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onHistoryTab(widget.history),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          spacing: 10,

          children: [
            SizedBox.square(
              dimension: 75,
              child: Image.network(
                      widget.restaurant.logoLink,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 75,
                          height: 75,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                        );
                      },
                    )
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.name,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),

                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      Expanded(
                        child: Text(
                          widget.restaurant.address,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Date: ${DateFormat("dd/MM/yyyy").format(widget.history.joinTime)}",
                    softWrap: true,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    widget.history.id.substring(0, 4),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "${widget.history.partySize} $guestSuffix",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
