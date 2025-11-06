import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  Future<Map<String, dynamic>?> ping() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/questions/'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

