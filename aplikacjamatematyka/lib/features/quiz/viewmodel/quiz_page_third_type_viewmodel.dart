import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum AnswerState { normal, selected, correct, wrong, disabled }

class QuizPageThirdTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;

  List<String> leftColumn = [];
  List<String> rightColumn = [];
  Map<String, String> correctPairs = {};

  String? selectedLeft;
  String? selectedRight;

  Map<String, AnswerState> answerStates = {};

  bool isLoading = true;
  String? errorMessage;

  double correctAnswersCount = 0;
  int totalAnswers = 0;
  int totalPairsInCurrentQuestion = 0;

  QuizPageThirdTypeViewModel() {
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final selectedCourse = selectedCourseNotifier.value;

      if (selectedCourse == null) {
        errorMessage = 'Nie wybrano kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      final matchQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'match',
      );

      if (matchQuestions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      allQuestions = matchQuestions;
      allQuestions.shuffle();

      isLoading = false;
      _loadCurrentQuestion();
    } catch (e) {
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadCurrentQuestion() {
    if (currentQuestionIndex >= allQuestions.length) return;

    final question = allQuestions[currentQuestionIndex];

    leftColumn = question.matchOptions.map((opt) => opt.leftText).toList();

    rightColumn = question.matchOptions
        .map((opt) => opt.rightText)
        .toList()
      ..shuffle();

    correctPairs = {
      for (var opt in question.matchOptions)
        opt.leftText: opt.rightText
    };

    totalPairsInCurrentQuestion = leftColumn.length;

    answerStates = {};
    for (int i = 0; i < leftColumn.length; i++) {
      answerStates['L:${leftColumn[i]}:$i'] = AnswerState.normal;
    }
    for (int i = 0; i < rightColumn.length; i++) {
      answerStates['R:${rightColumn[i]}:$i'] = AnswerState.normal;
    }

    selectedLeft = null;
    selectedRight = null;

    notifyListeners();
  }

  void onLeftTap(String item, int index) {
    String key = 'L:$item:$index';

    if (answerStates[key] == AnswerState.disabled ||
        answerStates[key] == AnswerState.correct) return;

    if (selectedLeft != null && selectedLeft != key) {
      if (answerStates[selectedLeft!] == AnswerState.selected) {
        answerStates[selectedLeft!] = AnswerState.normal;
      }
    }

    if (selectedLeft == key) {
      selectedLeft = null;
      answerStates[key] = AnswerState.normal;
    } else {
      selectedLeft = key;
      answerStates[key] = AnswerState.selected;
    }

    notifyListeners();
    _checkPair();
  }

  void onRightTap(String item, int index) {
    String key = 'R:$item:$index';

    if (answerStates[key] == AnswerState.disabled ||
        answerStates[key] == AnswerState.correct) return;

    if (selectedRight != null && selectedRight != key) {
      if (answerStates[selectedRight!] == AnswerState.selected) {
        answerStates[selectedRight!] = AnswerState.normal;
      }
    }

    if (selectedRight == key) {
      selectedRight = null;
      answerStates[key] = AnswerState.normal;
    } else {
      selectedRight = key;
      answerStates[key] = AnswerState.selected;
    }

    notifyListeners();
    _checkPair();
  }

  void _checkPair() async {
    if (selectedLeft == null || selectedRight == null) return;

    final leftKey = selectedLeft!;
    final rightKey = selectedRight!;

    final leftText = leftKey.split(':')[1];
    final rightText = rightKey.split(':')[1];

    final isMatch = correctPairs[leftText] == rightText;

    totalAnswers++;

    if (isMatch) {
      answerStates[leftKey] = AnswerState.correct;
      answerStates[rightKey] = AnswerState.correct;
      correctAnswersCount++;

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));

      answerStates[leftKey] = AnswerState.disabled;
      answerStates[rightKey] = AnswerState.disabled;

      selectedLeft = null;
      selectedRight = null;
    } else {
      answerStates[leftKey] = AnswerState.wrong;
      answerStates[rightKey] = AnswerState.wrong;

      if (correctAnswersCount > 0) {
        correctAnswersCount -= 0.5;
      }

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 800));

      answerStates[leftKey] = AnswerState.normal;
      answerStates[rightKey] = AnswerState.normal;

      selectedLeft = null;
      selectedRight = null;
    }

    notifyListeners();
  }

  bool get canConfirm =>
      answerStates.values.where((s) => s == AnswerState.disabled).length ==
      leftColumn.length * 2;

  void confirmAnswer() {
    currentQuestionIndex++;

    if (currentQuestionIndex < allQuestions.length) {
      _loadCurrentQuestion();
    } else {
      notifyListeners();
    }
  }

  bool get isQuizFinished =>
      !isLoading &&
      allQuestions.isNotEmpty &&
      currentQuestionIndex >= allQuestions.length;

  double get progress {
    if (allQuestions.isEmpty) return 0.0;
    return currentQuestionIndex / allQuestions.length;
  }

  double get scorePercentage {
    int maxPossiblePairs =
        allQuestions.fold(0, (sum, q) => sum + q.matchOptions.length);
    if (maxPossiblePairs == 0) return 0.0;
    return (correctAnswersCount / maxPossiblePairs) * 100;
  }

  int get remainingPairsInCurrentQuestion {
    int matched =
        answerStates.values.where((s) => s == AnswerState.disabled).length ~/ 2;
    return totalPairsInCurrentQuestion - matched;
  }

  Future<void> restartQuiz() async {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
    totalAnswers = 0;
    await _initializeQuiz();
  }

  void goToFinishQuiz() {
    selectedPageNotifier.value = 12;
  }
}
