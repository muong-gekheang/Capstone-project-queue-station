import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:queue_station_app/models/user/abstracts/user.dart';
import 'package:queue_station_app/models/user/history.dart';
import 'package:queue_station_app/models/user/store_user.dart';
import 'package:queue_station_app/services/user_provider.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';
import 'package:queue_station_app/ui/widgets/store_queue_history_card_widget.dart';

class StoreQueueHistory extends StatefulWidget {
  final Restaurant restaurant;
  const StoreQueueHistory({super.key, required this.restaurant});

  @override
  State<StoreQueueHistory> createState() => _StoreQueueHistoryState();
}

class _StoreQueueHistoryState extends State<StoreQueueHistory> {
  late Restaurant restaurant;
  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;
  }

  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  List<History> getHistoriesForRestaurant(StoreUser user) {
    List<History> filteredHistories = [];
    for (var history in mockHistories) {
      if (history.rest == user.rest) {
        filteredHistories.add(history);
      }
    }
    return filteredHistories;
  }

  //   String searchValue = '';
  Widget filteredQueueHistory() {
    StoreUser? user = context.read<UserProvider>().asStoreUser;
    List<History> histories = [];
    if (user != null) {
      histories = getHistoriesForRestaurant(user);
    }

    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index) =>
          StoreQueueHistoryCard(history: histories[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Queue History', color: Colors.black),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(
                      hintText: "search...",
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  ButtonWidget(
                    title: "Sort by",
                    onPressed: () {},
                    backgroundColor: Color.fromRGBO(255, 104, 53, 1),
                    textColor: Colors.white,
                    borderRadius: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(child: filteredQueueHistory()),
          ],
        ),
      ),
    );
  }
}
