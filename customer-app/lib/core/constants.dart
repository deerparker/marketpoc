import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:9000';
  static String get publishableApiKey =>
      dotenv.env['PUBLISHABLE_API_KEY'] ?? 'pk_flutter_test_key';

  static String sanitizeImageUrl(String url) {
    // If running on Android Emulator, replace localhost with 10.0.2.2
    // Since we can't easily detect emulator vs device here without dart:io Platform,
    // and if the user configured apiBaseUrl manually, we might want to respect that logic.
    // However, if the database returns 'localhost', it won't work on Android.

    // Simple heuristic: if apiBaseUrl contains 10.0.2.2, we should probably rewrite images too.
    if (apiBaseUrl.contains('10.0.2.2') && url.contains('localhost')) {
      return url.replaceAll('localhost', '10.0.2.2');
    }

    return url;
  }
}
