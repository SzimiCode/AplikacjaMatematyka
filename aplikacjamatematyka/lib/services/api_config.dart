import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Dla przeglądarki (Chrome, Firefox, etc.)
      return 'http://127.0.0.1:8000';
    } else if (Platform.isAndroid) {
      // Dla emulatora Android
      return 'http://10.0.2.2:8000';
    } else {
      // Dla iOS i innych platform
      return 'http://127.0.0.1:8000';
    }
  }
}