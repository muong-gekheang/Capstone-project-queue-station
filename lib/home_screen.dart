import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          spacing: 7,
          children: [
            Expanded(
              child: SearchRestWidget(
                suggestionsList: ["Apple", "Tomb", "Void", "Train"],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, color: Colors.black),
            ),
          ],
        ),
        SizedBox(
          height: 200,
          child: CarouselView.weighted(
            backgroundColor: Colors.blue,
            scrollDirection: Axis.horizontal,
            itemSnapping: true,
            flexWeights: const <int>[1, 10, 1],
            children: [Container(), Container(), Container(), Container()],
          ),
        ),
        Text(
          "Restaurants",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView(
            children: [
              RestaurantCard(
                name: 'Kungfu Kitchen',
                address: "BKK St.57",
                logoLink: '',
                currentWait: 1,
              ),
              RestaurantCard(
                name: 'Angle Hai',
                address: "STM St.57",
                logoLink: '',
                currentWait: 1,
              ),
              RestaurantCard(
                name: 'DoriDori Korean Chicken',
                address: 'AEON MALL SEN SOK',
                logoLink: '',
                currentWait: 1,
              ),
              RestaurantCard(
                name: '',
                address: '',
                logoLink: '',
                currentWait: 1,
              ),
              RestaurantCard(
                name: '',
                address: '',
                logoLink: '',
                currentWait: 1,
              ),
              RestaurantCard(
                name: '',
                address: '',
                logoLink: '',
                currentWait: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SearchRestWidget extends StatelessWidget {
  const SearchRestWidget({super.key, required this.suggestionsList});

  final List<String> suggestionsList;
  List<String> filterLogic(String search) {
    return suggestionsList
        .where((e) => e.toLowerCase().startsWith(search.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor.bar(
      isFullScreen: false,
      barHintText: "Search",
      constraints: BoxConstraints(maxHeight: 36, minHeight: 36),
      barShape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      suggestionsBuilder: (context, controller) {
        return [...filterLogic(controller.text).map((e) => Text(e))];
      },
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
    required this.name,
    required this.logoLink,
    required this.currentWait,
    required this.address,
  });
  final String name;
  final String logoLink;
  final int currentWait;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      child: Row(
        spacing: 10,
        children: [
          SizedBox(height: 50, width: 50, child: Placeholder()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Row(children: [Icon(Icons.location_pin), Text(address)]),
              Row(
                children: [
                  Icon(Icons.hourglass_empty),
                  Text("$currentWait people waiting"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: HomeScreen()),
    ),
  );
}
