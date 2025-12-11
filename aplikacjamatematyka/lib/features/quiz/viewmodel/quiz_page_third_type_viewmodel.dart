import 'package:flutter/material.dart';
import '../data/questionsThird.dart';

enum AnswerState { normal, selected, correct, wrong, disabled }

class QuizPageThirdTypeViewModel extends ChangeNotifier {
  int currentQuestionIndex = 0;

  List<String> leftColumn = [];
  List<String> rightColumn = [];
  Map<String, String> correctPairs = {};

  String? selectedLeft;
  String? selectedRight;

  Map<String, AnswerState> answerStates = {};

  QuizPageThirdTypeViewModel() {
    _loadCurrentQuestion();
  }

  void _loadCurrentQuestion() {
    final question = questionsThird[currentQuestionIndex];

    leftColumn = List.of(question.left);
    rightColumn = List.of(question.right)..shuffle();
    correctPairs = Map.of(question.correct);

    answerStates = {
      for (var item in [...leftColumn, ...rightColumn])
        item: AnswerState.normal
    };

    selectedLeft = null;
    selectedRight = null;

    notifyListeners();
  }

  void onLeftTap(String item) {
    if (answerStates[item] == AnswerState.disabled ||
        answerStates[item] == AnswerState.correct) return;

    selectedLeft = item;
    answerStates[item] = AnswerState.selected;

    notifyListeners();
    _checkPair();
  }

  void onRightTap(String item) {
    if (answerStates[item] == AnswerState.disabled ||
        answerStates[item] == AnswerState.correct) return;

    selectedRight = item;
    answerStates[item] = AnswerState.selected;

    notifyListeners();
    _checkPair();
  }

  void _checkPair() async {
    if (selectedLeft == null || selectedRight == null) return;

    final left = selectedLeft!;
    final right = selectedRight!;

    final isMatch = correctPairs[left] == right;

    if (isMatch) {
      // poprawna para → zielone i blokada
      answerStates[left] = AnswerState.correct;
      answerStates[right] = AnswerState.correct;

      await Future.delayed(const Duration(milliseconds: 300));

      answerStates[left] = AnswerState.disabled;
      answerStates[right] = AnswerState.disabled;
    } else {

      answerStates[left] = AnswerState.wrong;
      answerStates[right] = AnswerState.wrong;

      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));

      answerStates[left] = AnswerState.normal;
      answerStates[right] = AnswerState.normal;
    }

    selectedLeft = null;
    selectedRight = null;

    notifyListeners();
  }

  bool get canConfirm =>
      answerStates.values.where((s) => s == AnswerState.disabled).length ==
      leftColumn.length * 2;

  void confirmAnswer() {
    currentQuestionIndex++;

    if (currentQuestionIndex < questionsThird.length) {
      _loadCurrentQuestion();
    } else {
      notifyListeners();
    }
  }

  bool get isQuizFinished => currentQuestionIndex >= questionsThird.length;
}
