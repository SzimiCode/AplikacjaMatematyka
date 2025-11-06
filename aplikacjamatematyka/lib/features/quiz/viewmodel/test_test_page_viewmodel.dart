import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikacjamatematyka/services/api_service.dart';

class TestTestPageViewmodel {
  final ApiService api = ApiService();
  Map<String, dynamic>? questionData;  // dane pytania z api
  ValueNotifier<bool> isLoading = ValueNotifier(true);  // czy laduje
  ValueNotifier<String?> feedback = ValueNotifier(null);  // komunikat dla usera
  
  // // pobiera pytanie z django api
  // Future<void> loadQuestion() async {
  //   isLoading.value = true;
  //   final url = Uri.parse('http://127.0.0.1:8000/api/questions/');
    
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final List<dynamic> questions = jsonDecode(response.body);
  //       if (questions.isNotEmpty) {
  //         questionData = questions[0];  // bierze pierwsze pytanie z listy
  //         feedback.value = null;
  //       } else {
  //         feedback.value = "Brak pytań w bazie";
  //       }
  //     } else {
  //       feedback.value = "Błąd: ${response.statusCode}";
  //     }
  //   } catch (e) {
  //     feedback.value = "Exception: $e";  // jak sie wywali to pokazuje blad
  //   }
    
  //   isLoading.value = false;
  // }

  Future<void> loadQuestion() async {
    isLoading.value = true;

    final data = await api.fetchRandomQuestion();

    if (data == null) {
      feedback.value = "Błąd pobierania pytania";
      questionData = null;
    } else {
      questionData = data;  // <-- już poprawnie
    }

    isLoading.value = false;
  }
  
  
  // sprawdza czy user kliknal dobra odpowiedz
  void onAnswerPressed(String letter) {
    if (questionData == null) return;
    
    final index = "ABCD".indexOf(letter);  // zamienia A/B/C/D na 0/1/2/3
    if (index < 0 || index >= questionData!["options"].length) return;
    
    final option = questionData!["options"][index];
    if (option["is_correct"] == true) {
      feedback.value = "✅ Poprawna odpowiedź!";
    } else {
      feedback.value = "❌ Zła odpowiedź!";
    }
  }
  
  // funkcja do cofania (jeszcze nie uzywana, ale moze sie przyda)
  void onBackButtonPressed(ValueNotifier<int> selectedPageNotifier) {
    selectedPageNotifier.value = 0;  // wraca na strone glowna
  }
}