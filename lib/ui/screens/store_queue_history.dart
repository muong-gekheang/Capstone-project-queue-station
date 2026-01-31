import 'package:flutter/material.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/ui/widgets/appbar_widget.dart';
import 'package:queue_station_app/ui/widgets/button_widget.dart';
import 'package:queue_station_app/ui/widgets/searchbar_widget.dart';
import 'package:queue_station_app/ui/widgets/store_queue_history_card_widget.dart';

class StoreQueueHistory extends StatefulWidget {
  const StoreQueueHistory({super.key});

  @override
  State<StoreQueueHistory> createState() => _StoreQueueHistoryState();
}

class _StoreQueueHistoryState extends State<StoreQueueHistory> {
  
  Widget FilteredQueueHistory(){
    final results = mockQueueHistories;
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) => StoreQueueHistoryCard(storeQueueHistory: results[index]) );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: 'Queue History', color: Colors.black,),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: SearchbarWidget(hintText: "search...",),
                  ),
                  SizedBox(width: 10),
                  ButtonWidget(
                    title: "Sort by", 
                    onPressed: (){}, 
                    backgroundColor: Color.fromRGBO(255, 104, 53, 1), 
                    textColor: Colors.white, 
                    borderRadius: 50, 
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FilteredQueueHistory(),
            ),
          ],
        ),
      ),
    );
  }
}