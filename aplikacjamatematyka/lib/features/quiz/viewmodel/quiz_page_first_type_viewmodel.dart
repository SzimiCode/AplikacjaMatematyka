import 'package:flutter/material.dart';
import '../data/questions.dart';

class QuizPageFirstTypeViewModel extends ChangeNotifier {
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<String> shuffledAnswers = [];
  final TextEditingController answerController = TextEditingController();


  QuizPageFirstTypeViewModel() {
    _shuffleCurrentQuestionAnswers();
  }

  void _shuffleCurrentQuestionAnswers() {
    shuffledAnswers = List.of(questions[currentQuestionIndex].answers)..shuffle();
  }

  String get currentQuestionText => questions[currentQuestionIndex].text;

  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  bool get canConfirm => selectedAnswer != null;

  void confirmAnswer() {
    if (!canConfirm) return;

    selectedAnswer = null;
    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
      _shuffleCurrentQuestionAnswers();
    }
    notifyListeners();
  }

  bool get isQuizFinished => currentQuestionIndex >= questions.length;
}
