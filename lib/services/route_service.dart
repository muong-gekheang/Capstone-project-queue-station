import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// --- NEW: Custom class to hold both points and distance ---
class RouteData {
  final List<LatLng> points;
  final int distanceMeters;

  RouteData({required this.points, required this.distanceMeters});
}

class RouteService {
  final String apiKey;

  RouteService(this.apiKey);

  Future<RouteData?> getRouteData(LatLng origin, LatLng destination) async {
    const url = "https://routes.googleapis.com/directions/v2:computeRoutes";

    final body = {
      "origin": {
        "location": {
          "latLng": {
            "latitude": origin.latitude,
            "longitude": origin.longitude,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination.latitude,
            "longitude": destination.longitude,
          },
        },
      },
      "travelMode": "DRIVE",
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        // --- UPDATED: Ask Google for both the Polyline AND the Distance! ---
        "X-Goog-FieldMask":
            "routes.polyline.encodedPolyline,routes.distanceMeters",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    if (data["routes"] == null || data["routes"].isEmpty) return null;

    final route = data["routes"][0];
    final encoded = route["polyline"]["encodedPolyline"];
    final distanceMeters = route["distanceMeters"] ?? 0;

    final points = PolylinePoints.decodePolyline(
      encoded,
    ).map((p) => LatLng(p.latitude, p.longitude)).toList();

    return RouteData(points: points, distanceMeters: distanceMeters);
  }
}
