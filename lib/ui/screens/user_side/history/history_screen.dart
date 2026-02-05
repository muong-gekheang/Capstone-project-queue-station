import 'package:flutter/material.dart';
import 'package:queue_station_app/model/history.dart';
import 'package:queue_station_app/ui/screens/user_side/history/history_list_view.dart';
import 'package:queue_station_app/ui/screens/user_side/home/home_screen.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';
import 'package:queue_station_app/ui/screens/user_side/history/sort_button.dart';

enum SortType { recent, byMonth, byYear }

List<History> mockHistsoryData = [
  History(
    rest: mockData[0],
    guests: 4,
    queueId: "D057",
    queueDate: DateTime.now(),
    status: StatusType.Completed,
  ),
  History(
    rest: mockData[1],
    guests: 4,
    queueId: "D057",
    queueDate: DateTime.now().subtract(Duration(hours: 10)),
    status: StatusType.Completed,
  ),
  History(
    rest: mockData[2],
    guests: 4,
    queueId: "D057",
    queueDate: DateTime.now().subtract(Duration(days: 10)),
    status: StatusType.Completed,
  ),
  History(
    rest: mockData[3],
    guests: 4,
    queueId: "D057",
    queueDate: DateTime.now().subtract(Duration(days: 20)),
    status: StatusType.Completed,
  ),
  History(
    rest: mockData[4],
    guests: 4,
    queueId: "D057",
    queueDate: DateTime.now().subtract(Duration(days: 30)),
    status: StatusType.Completed,
  ),
];

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
    List<History> sortedList = [...mockHistsoryData];
    sortedList.sort((a, b) => b.queueDate.compareTo(a.queueDate));
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
    return Scaffold(
      // bottomNavigationBar: , //TODO: Add nav bar
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: Column(
          spacing: 20,
          children: [
            SearchWidget<History>(
              filterLogic: (String search) {
                Set<History> filteredList = mockHistsoryData
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
      ),
    );
  }
}

// void main() {
//   runApp(
//     MaterialApp(
//       theme: AppTheme.lightTheme,
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "History",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//         ),
//         body: SafeArea(child: HistoryScreen()),
//       ),
//     ),
//   );
// }
