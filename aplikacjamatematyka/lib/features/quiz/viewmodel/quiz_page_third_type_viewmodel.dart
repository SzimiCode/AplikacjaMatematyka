import 'package:flutter/material.dart';
import '../data/questionsThird.dart';

class QuizPageThirdTypeViewModel extends ChangeNotifier {
  int currentQuestionIndex = 0;

  List<String> leftColumn = [];
  List<String> rightColumn = [];
  Map<String, String> correctPairs = {};

  String? selectedLeft;
  String? selectedRight;

  List<String> matched = [];

  QuizPageThirdTypeViewModel() {
    _loadCurrentQuestion();
  }

  void _loadCurrentQuestion() {
    final question = questionsThird[currentQuestionIndex];

    leftColumn = List.of(question.left);
    rightColumn = List.of(question.right)..shuffle();
    correctPairs = Map.of(question.correct);

    selectedLeft = null;
    selectedRight = null;
    matched = [];

    notifyListeners();
  }

  String get currentQuestionText =>
      "Dopasuj elementy"; 

  void onLeftTap(String item) {
    selectedLeft = item;
    notifyListeners();
    _checkPair();
  }

  void onRightTap(String item) {
    selectedRight = item;
    notifyListeners();
    _checkPair();
  }

  void _checkPair() {
    if (selectedLeft == null || selectedRight == null) return;

    final isMatch = correctPairs[selectedLeft] == selectedRight;

    if (isMatch) {
      matched.add(selectedLeft!);
    }

    selectedLeft = null;
    selectedRight = null;

    notifyListeners();
  }

  bool get canConfirm => matched.length == leftColumn.length;

  void confirmAnswer() {
    if (!canConfirm) return;

    currentQuestionIndex++;

    if (currentQuestionIndex < questionsThird.length) {
      _loadCurrentQuestion();
    } else {
      notifyListeners();
    }
  }

  bool get isQuizFinished => currentQuestionIndex >= questionsThird.length;
}
