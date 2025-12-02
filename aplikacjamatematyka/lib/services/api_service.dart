import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Zmień na swój adres IP jeśli testujesz na fizycznym urządzeniu
  // Na emulatorze Androida: http://10.0.2.2:8000
  // Na iOS simulator: http://127.0.0.1:8000
  // Na fizycznym urządzeniu: http://TWOJE_IP:8000
  final String baseUrl = "http://127.0.0.1:8000";

  // ========== TOKEN MANAGEMENT ==========
  
  // Zapisz token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  // Pobierz token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Usuń token (logout)
  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  // Headers z tokenem
  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ========== AUTH ENDPOINTS ==========

  // REJESTRACJA
  Future<Map<String, dynamic>> register({
    required String email,
    required String nick,
    required String fullName,
    required String phoneNumber,
    required String password,
    required String password2,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'nick': nick,
          'full_name': fullName,
          'phone_number': phoneNumber,
          'password': password,
          'password2': password2,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Zapisz token
        await saveToken(data['access']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data};
      }
    } catch (e) {
      return {'success': false, 'error': 'Błąd połączenia: $e'};
    }
  }

  // LOGOWANIE
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Zapisz token
        await saveToken(data['access']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Błąd logowania'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Błąd połączenia: $e'};
    }
  }

  // POBIERZ PROFIL
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final headers = await getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/'),
        headers: headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': 'Nie udało się pobrać profilu'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Błąd połączenia: $e'};
    }
  }

  // WYLOGUJ
  Future<void> logout() async {
    await removeToken();
  }

  // ========== EXISTING ENDPOINTS ==========

  // funkcja testowa - zwraca losowe pytanie
  Future<Map<String, dynamic>?> fetchRandomQuestion() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/get-question/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // pobiera wszystkie pytania
  Future<List<dynamic>?> fetchAllQuestions() async {
    try {
      final url = Uri.parse("$baseUrl/api/questions/");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // pobiera wszystkie kategorie
  Future<List<dynamic>?> fetchAllCategories() async {
    try {
      final url = Uri.parse("$baseUrl/api/categories/");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // pobiera wszystkie kursy
  Future<List<dynamic>?> fetchAllCourses() async {
    try {
      final url = Uri.parse("$baseUrl/api/courses/");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}