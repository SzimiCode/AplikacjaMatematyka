import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/services/api_service.dart';

class TestTestPageViewmodel {
  final ApiService api = ApiService();

  // Pula wylosowanych pytań (maksymalnie 10)
  List<dynamic> questions = [];

  // Index aktualnego pytania
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  // Punkty zdobyte (liczone tylko przy poprawnej pierwszej odpowiedzi)
  final ValueNotifier<int> score = ValueNotifier<int>(0);

  // Flaga czy aktualne pytanie zostało już odpowiedziane (uniemożliwia wielokrotne punkty)
  final ValueNotifier<bool> answered = ValueNotifier<bool>(false);

  // Wskaźniki UI
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<String?> feedback = ValueNotifier<String?>(null);

  Map<String, dynamic>? get currentQuestion {
    if (questions.isEmpty) return null;
    final idx = currentIndex.value;
    if (idx < 0 || idx >= questions.length) return null;
    return questions[idx] as Map<String, dynamic>;
  }

  int get totalQuestions => questions.length;

  /// Pobiera wszystkie pytania z API, losuje maksymalnie 10 i resetuje stan testu.
  Future<void> loadTestQuestions() async {
    isLoading.value = true;
    feedback.value = null;

    final all = await api.fetchAllQuestions();
    if (all == null || all.isEmpty) {
      feedback.value = "Brak pytań w bazie";
      questions = [];
      isLoading.value = false;
      return;
    }

    // Losujemy i bierzemy maksymalnie 10 unikalnych pytań
    final rnd = Random();
    all.shuffle(rnd);
    questions = all.take(10).toList();

    // Reset stanu
    currentIndex.value = 0;
    score.value = 0;
    answered.value = false;
    feedback.value = null;
    isLoading.value = false;
  }

  /// Obsługa kliknięcia odpowiedzi (A/B/C/D). Naliczanie punktów tylko przy pierwszym kliknięciu.
  void onAnswerPressed(String letter) {
    final question = currentQuestion;
    if (question == null) return;
    if (answered.value) return; // tylko pierwsze kliknięcie ma znaczenie

    final index = "ABCD".indexOf(letter);
    if (index < 0) return;

    final options = question["options"] as List<dynamic>? ?? [];
    if (index >= options.length) return;

    final option = options[index] as Map<String, dynamic>;
    final bool isCorrect = option["is_correct"] == true;

    if (isCorrect) {
      // tylko przy pierwszym poprawnym kliknięciu dodaj punkt
      score.value = score.value + 1;
      feedback.value = "✅ Poprawna odpowiedź!";
    } else {
      feedback.value = "❌ Zła odpowiedź!";
    }

    answered.value = true;
  }

  /// Przechodzi do następnego pytania. Jeśli test się skończył, ustawia feedback z wynikiem.
  void nextQuestion() {
    if (!answered.value) return; // nie przechodź, jeśli nie odpowiedziano

    if (currentIndex.value + 1 < questions.length) {
      currentIndex.value = currentIndex.value + 1;
      // reset stanu na nowe pytanie
      answered.value = false;
      feedback.value = null;
    } else {
      // koniec testu — wyświetl wynik
      feedback.value = "Koniec testu — zdobyte punkty: ${score.value} / ${questions.length}";
    }
  }

  /// Pozwala wyjść z testu — reset minimalny (jeśli chcesz pełny reset, możesz użyć loadTestQuestions)
  void exitTest() {
    // nie czyścimy pytań, bo użytkownik może chcieć wrócić — ale można to rozszerzyć
    answered.value = false;
    feedback.value = null;
  }
}