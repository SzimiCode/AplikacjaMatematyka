import 'package:aplikacjamatematyka/features/quiz/data/questionsSecond.dart';
import 'package:flutter/material.dart';

enum AnswerState { normal, correct, wrong }

class QuizPageSecondTypeViewModel extends ChangeNotifier {
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();

  AnswerState answerState = AnswerState.normal;

  QuizPageSecondTypeViewModel() {
    answerController.addListener(() {
      notifyListeners(); 
    });
  }

  String get currentQuestionText =>
      questionsSecond[currentQuestionIndex].text;

  bool get canConfirm => answerController.text.trim().isNotEmpty;


  void confirmAnswer() {
    if (!canConfirm) return;

    final userAnswer = answerController.text;
    final correctAnswer = questionsSecond[currentQuestionIndex].answer;

    final normalizedUser = userAnswer.replaceAll(' ', '').toLowerCase();
    final normalizedCorrect = correctAnswer.replaceAll(' ', '').toLowerCase();

    if (normalizedUser == normalizedCorrect) {
      answerState = AnswerState.correct;
    } else {
      answerState = AnswerState.wrong;
    }

    notifyListeners();

    Future.delayed(const Duration(milliseconds: 700), () {
      answerState = AnswerState.normal;
      answerController.clear();
      currentQuestionIndex++;
      notifyListeners();
    });
  }

  bool get isQuizFinished => currentQuestionIndex >= questionsSecond.length;

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}
