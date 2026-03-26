import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
// import 'package:queue_station_app/data/mock_restaurant.dart';
import 'package:queue_station_app/data/repositories/map/map_repo_impl.dart';
// import 'package:queue_station_app/data/repositories/map/restaurant_repo_mock.dart';
import 'package:queue_station_app/data/repositories/map/map_repository.dart';
import 'package:queue_station_app/data/repositories/map/social/social_account_repository.dart';
import 'package:queue_station_app/data/repositories/map/social/social_account_repository_impl.dart';
import 'package:queue_station_app/firebase_options.dart';
import 'package:queue_station_app/ui/screens/map/map_screen.dart';
// import 'package:queue_station_app/ui/screens/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.authStateChanges().first;
  await dotenv.load(fileName: ".env");

  // --- NEW: Read the URL from the Chrome Address Bar! ---
  // If the URL is http://localhost:55555/?id=123, this will extract "123"
  final String? deepLinkId = Uri.base.queryParameters['id'];

  runApp(
    MultiProvider(
      providers: [
        Provider<MapRepository>(
          create: (_) => MapRepositoryImpl(),
          // MockRestaurantRepository(),
        ),
        Provider<SocialAccountRepository>(
          create: (_) => SocialAccountRepositoryImpl(),
          // MockRestaurantRepository(),
        ),
      ],
      child: MyApp(initialId: deepLinkId),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initialId;

  const MyApp({super.key, this.initialId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFFFF6835),
      ),
      home: MapScreen(
        // ownRestaurantId: mockRestaurants[0].id,
        initialRestaurantId: initialId,
      ),
    );
  }
}
