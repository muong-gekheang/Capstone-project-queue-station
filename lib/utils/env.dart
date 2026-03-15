import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get mapsKey => _getSafe('MAPS_API_KEY');

  static void validate() {
    mapsKey;
    print("✅ Environment variables validated.");
  }

  static String _getSafe(String key) {
    final value = dotenv.maybeGet(key);
    if (value == null || value.isEmpty) {
      throw Exception('❌ Missing "$key" in your .env file.');
    }
    return value;
  }
}
