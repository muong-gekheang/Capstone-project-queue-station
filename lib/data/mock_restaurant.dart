// import 'package:queue_station_app/data/store_queue_history_data.dart';
// import 'package:queue_station_app/models/restaurant/restaurant.dart';

// List<Restaurant> mockRestaurants = [
//   Restaurant(
//     id: "test 1",
//     name: 'Kungfu Kitchen',
//     address: "BKK St.57",
//     logoLink: '',
//     biggestTableSize: 10,
//     phone: "012255007",
//     items: [],
//     tables: [],
//     globalAddOns: [],
//     globalSizeOptions: [],
//   ),
//   Restaurant(
//     id: "test 1",
//     name: 'Angle Hai',
//     address: "STM St.57",
//     logoLink: '',
//     biggestTableSize: 10,
//     phone: "012255007",
//     items: [],
//     tables: [],
//     globalAddOns: [],
//     globalSizeOptions: [],
//   ),
//   Restaurant(
//     id: "test 1",
//     name: 'DoriDori Korean Chicken',
//     address: 'AEON MALL SEN SOK',
//     logoLink: '',
//     biggestTableSize: 10,
//     phone: "012255007",
//     items: [],
//     tables: [],
//     globalAddOns: [],
//     globalSizeOptions: [],
//   ),
//   Restaurant(
//     id: "test 1",
//     name: 'Kungfu Kitchen',
//     address: "BKK St.57",
//     logoLink: '',
//     biggestTableSize: 10,
//     phone: "012255007",
//     items: [],
//     tables: [],
//     globalAddOns: [],
//     globalSizeOptions: [],
//   ),
//   Restaurant(
//     id: "test 1",
//     name: 'Kungfu Kitchen',
//     address: "BKK St.57",
//     logoLink: '',
//     biggestTableSize: 10,
//     phone: "012255007",
//     items: [],
//     tables: [],
//     globalAddOns: [],
//     globalSizeOptions: [],
//   ),
// ];
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:queue_station_app/data/store_queue_history_data.dart';
import 'package:queue_station_app/models/restaurant/restaurant.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

List<Restaurant> mockRestaurants = [
  Restaurant(
    id: "test-1",
    name: 'Kungfu Kitchen',
    address: "BKK1, St. 57",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012 255 001",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
    location: const LatLng(11.5512, 104.9281), // BKK1 Area
    contactDetails: [],
  ),
  Restaurant(
    id: "test-2",
    name: 'Angkea Hai',
    address: "Toul Tom Poung, St. 155",
    logoLink: '',
    biggestTableSize: 8,
    phone: "012 255 002",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
    location: const LatLng(11.5401, 104.9125), // Russian Market Area
    contactDetails: [],
  ),
  Restaurant(
    id: "test-3",
    name: 'DoriDori Korean Chicken',
    address: 'Aeon Mall Sen Sok',
    logoLink: '',
    biggestTableSize: 6,
    phone: "012 255 003",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
    location: const LatLng(11.5940, 104.8845), // North Sen Sok
    contactDetails: [],
  ),
  Restaurant(
    id: "test-4",
    name: 'Riverside Bistro',
    address: "Sisowath Quay, Riverside",
    logoLink: '',
    biggestTableSize: 12,
    phone: "012 255 004",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
    location: const LatLng(11.5685, 104.9300), // Riverside Area
    contactDetails: [],
  ),
  Restaurant(
    id: "test-5",
    name: 'The Pizza Company',
    address: "Toul Kork, St. 289",
    logoLink: '',
    biggestTableSize: 10,
    phone: "012 255 005",
    items: [],
    tables: [],
    globalAddOns: [],
    globalSizeOptions: [],
    location: const LatLng(11.5815, 104.8995), // Toul Kork Area
    contactDetails: [],
  ),
];
