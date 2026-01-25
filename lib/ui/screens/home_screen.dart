import 'package:flutter/material.dart';
import 'package:queue_station_app/model/restaurant.dart';
import 'package:queue_station_app/ui/app_theme.dart';
import 'package:queue_station_app/ui/screens/join_queue_screen.dart';
import 'package:queue_station_app/ui/widgets/search_widget.dart';

List<Restaurant> mockData = [
  Restaurant(
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
  ),
  Restaurant(
    name: 'Angle Hai',
    address: "STM St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
  ),
  Restaurant(
    name: 'DoriDori Korean Chicken',
    address: 'AEON MALL SEN SOK asdsds',
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
  ),
  Restaurant(
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
  ),
  Restaurant(
    name: 'Kungfu Kitchen',
    address: "BKK St.57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012255007",
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: 7,
            children: [
              Expanded(
                child: SearchWidget<Restaurant>(
                  filterLogic: (String search) {
                    Set<Restaurant> filteredList = mockData
                        .where(
                          (e) => e.name.toLowerCase().startsWith(
                            search.toLowerCase(),
                          ),
                        )
                        .toSet();
                    return filteredList
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RestaurantCard(rest: e),
                          ),
                        )
                        .toList();
                  },
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: CarouselView.weighted(
              scrollDirection: Axis.horizontal,
              itemSnapping: true,
              flexWeights: const <int>[10],
              children: [
                Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
                Image.asset("assets/home_screen/MOMO.png", fit: BoxFit.cover),
              ],
            ),
          ),
          Text(
            "Restaurants",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: mockData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2,
                  ),
                  child: RestaurantCard(rest: mockData[index]),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatefulWidget {
  const RestaurantCard({super.key, required this.rest});

  final Restaurant rest;

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  Future<void> onRestTap(Restaurant rest) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return JoinQueueScreen(rest: widget.rest);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => onRestTap(widget.rest),
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
                  widget.rest.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Row(
                  children: [
                    Icon(Icons.location_pin),
                    Text(widget.rest.address),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.hourglass_empty, color: Color(0xFFFF6835)),
                    Text(
                      "${widget.rest.curWait} people waiting",
                      style: TextStyle(color: Color(0xFFFF6835)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: HomeScreen()),
      ),
    ),
  );
}
