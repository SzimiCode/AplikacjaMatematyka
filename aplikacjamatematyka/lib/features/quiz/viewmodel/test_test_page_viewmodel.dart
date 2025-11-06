import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestTestPageViewmodel {
  Map<String, dynamic>? questionData;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<String?> feedback = ValueNotifier(null);

  // Pobieranie pytania z API
  Future<void> loadQuestion() async {
  isLoading.value = true;
  final url = Uri.parse('http://127.0.0.1:8000/api/questions/');
  
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> questions = jsonDecode(response.body);
        if (questions.isNotEmpty) {
          questionData = questions[0]; // <- weź pierwsze pytanie
          feedback.value = null;
        } else {
          feedback.value = "Brak pytań w bazie";
        }
      } else {
        feedback.value = "Błąd: ${response.statusCode}";
      }
    } catch (e) {
      feedback.value = "Exception: $e";
    }
    
    isLoading.value = false;
  }

  // Obsługa odpowiedzi użytkownika
  void onAnswerPressed(String letter) {
    if (questionData == null) return;

    final index = "ABCD".indexOf(letter);
    if (index < 0 || index >= questionData!["options"].length) return;

    final option = questionData!["options"][index];
    if (option["is_correct"] == true) {
      feedback.value = "✅ Poprawna odpowiedź!";
    } else {
      feedback.value = "❌ Zła odpowiedź!";
    }
  }
  

  // Cofanie do strony głównej
  void onBackButtonPressed(ValueNotifier<int> selectedPageNotifier) {
    selectedPageNotifier.value = 0;
  }
}