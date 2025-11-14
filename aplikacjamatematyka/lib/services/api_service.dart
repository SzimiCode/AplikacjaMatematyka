import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000";
  
  // funkcja testowa - sprawdza czy api dziala
  // teraz odpytuje /api/questions/ ale nazwa sugeruje ze to byl ping
  Future<Map<String, dynamic>?> fetchRandomQuestion() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/get-question/'));
      if (response.statusCode == 200) {
        return json.decode(response.body);  // zwraca zdekodowany json
      } else {
        return null;  // jak blad to null
      }
    } catch (e) {
      return null;  // jak exception to tez null
    }
  }
  // pobiera wszystkie pytania (do testow)
  Future<List<dynamic>?> fetchAllQuestions() async {
  try {
    final url = Uri.parse("$baseUrl/api/questions/");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body); // lista pytań
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