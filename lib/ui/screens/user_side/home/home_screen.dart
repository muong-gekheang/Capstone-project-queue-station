import 'package:flutter/material.dart';
import 'package:queue_station_app/model/restaurant.dart';
import 'package:queue_station_app/ui/screens/user_side/home/widgets/restaurant_tile.dart';
import 'package:queue_station_app/ui/screens/user_side/join_queue/join_queue_screen.dart';
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
    address: 'AEON MALL SEN SOK',
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<String> iconPaths = [
    'assets/images/home_icon.svg',
    'assets/images/map_icon.svg',
    'assets/images/food_ordering_icon.svg',
    'assets/images/ticket_confirmation.svg',
    'assets/images/profile_icon.svg',
  ];

  final List<String> labels = [
    'Home',
    'Map',
    'Ticket Confirmation',
    'Orders',
    'Profile',
  ];

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
                            child: RestaurantTile(rest: e),
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
                  child: RestaurantTile(rest: mockData[index]),
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
