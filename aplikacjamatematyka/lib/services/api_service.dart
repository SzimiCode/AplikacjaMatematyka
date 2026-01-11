// lib/core/api/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";

  // ========== TOKEN MANAGEMENT ==========
  
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ========== AUTH ENDPOINTS ==========

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
        await saveToken(data['access']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data};
      }
    } catch (e) {
      return {'success': false, 'error': 'Błąd połączenia: $e'};
    }
  }

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
        await saveToken(data['access']);
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'error': data['error'] ?? 'Błąd logowania'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Błąd połączenia: $e'};
    }
  }

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

  Future<void> logout() async {
    await removeToken();
  }

  // ========== CLASS, CATEGORY, COURSE ENDPOINTS ==========

  Future<List<dynamic>?> fetchClasses() async {
    try {
      print('🌐 API: Fetching classes from $baseUrl/api/classes/');
      final response = await http.get(Uri.parse('$baseUrl/api/classes/'));
      print('📡 API Response status: ${response.statusCode}');
      print('📡 API Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print('✅ API: Successfully decoded ${decoded.length} classes');
        return decoded;
      }
      print('❌ API: Status code not 200');
      return null;
    } catch (e) {
      print('❌ API Error fetching classes: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchCategories({int? classId}) async {
    try {
      String url = '$baseUrl/api/categories/';
      if (classId != null) {
        url += '?class_id=$classId';
      }
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching categories: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchCourses({int? categoryId}) async {
    try {
      String url = '$baseUrl/api/courses/';
      if (categoryId != null) {
        url += '?category_id=$categoryId';
      }
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching courses: $e');
      return null;
    }
  }

  // 🔹 NOWY ENDPOINT - Pobierz szczegóły kursu z pełnym URL wideo
  Future<Map<String, dynamic>?> fetchCourseDetail(int courseId) async {
    try {
      print('🌐 API: Fetching course detail for ID: $courseId');
      final response = await http.get(
        Uri.parse('$baseUrl/api/courses/$courseId/'),
      );
      
      print('📡 API Response status: ${response.statusCode}');
      print('📡 API Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ API: Successfully fetched course detail');
        print('🎬 Video URL: ${data['full_video_url']}');
        return data;
      }
      print('❌ API: Status code not 200');
      return null;
    } catch (e) {
      print('❌ API Error fetching course detail: $e');
      return null;
    }
  }

  Future<List<dynamic>?> fetchQuestions({
    required int courseId,
    String? questionType,
    int? difficultyId,
  }) async {
    try {
      String url = '$baseUrl/api/courses/$courseId/questions/';
      
      List<String> params = [];
      if (questionType != null) params.add('type=$questionType');
      if (difficultyId != null) params.add('difficulty=$difficultyId');
      
      if (params.isNotEmpty) url += '?${params.join('&')}';
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching questions: $e');
      return null;
    }
  }

  // ========== EXISTING ENDPOINTS ==========

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