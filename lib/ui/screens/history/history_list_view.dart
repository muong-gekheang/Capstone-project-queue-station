import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queue_station_app/model/history.dart';
import 'package:queue_station_app/ui/screens/history/history_screen.dart';
import 'package:queue_station_app/ui/screens/history/history_view_screen.dart';

class HistoryListView extends StatelessWidget {
  const HistoryListView({
    super.key,
    required this.historyList,
    required this.currentSortType,
  });

  final List<History> historyList;
  final SortType currentSortType;

  List<Widget> get uiItems {
    String? lastGroup;
    String? currentGroup;
    String dateDisplayFormat = currentSortType == SortType.byMonth
        ? "MMM yyyy"
        : "yyyy";

    List<Widget> widgetList = [];

    for (var h in historyList) {
      if (currentSortType != SortType.recent) {
        currentGroup = DateFormat(dateDisplayFormat).format(h.queueDate);
        if (currentGroup != lastGroup) {
          widgetList.add(HistoryTitle(currentGroup: currentGroup));
          lastGroup = currentGroup;
        }
      }

      widgetList.add(HistoryCard(history: h));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: uiItems.length,
        itemBuilder: (context, index) {
          return uiItems[index];
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
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
  const HistoryCard({super.key, required this.history});
  final History history;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  Future<void> onHistoryTab(History history) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return HistoryViewScreen(history: history);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String guestSuffix = widget.history.guests > 1 ? "People" : "Person";
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
              child: Image.asset(
                "assets/home_screen/kungfu.png",
                fit: BoxFit.fitHeight,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.history.rest.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),

                Row(
                  children: [
                    Icon(Icons.location_pin),
                    Text(widget.history.rest.address),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Date: ${DateFormat("dd/MM/yyyy").format(widget.history.queueDate)}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  widget.history.queueId,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "${widget.history.guests} $guestSuffix",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
