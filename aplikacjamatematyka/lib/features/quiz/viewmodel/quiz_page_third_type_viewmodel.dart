import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:flutter/material.dart';
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

  QuizPageThirdTypeViewModel() {
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    final selectedCourse = selectedCourseNotifier.value;
    if (selectedCourse == null) return;

    final matchQuestions = await _repository.getQuestions(
      courseId: selectedCourse.id,
      questionType: 'match',
    );

    allQuestions = matchQuestions;
    allQuestions.shuffle();
    
    _loadCurrentQuestion();
  }

  void goToFinishQuiz() {
    selectedPageNotifier.value = 12;
  }

  void _loadCurrentQuestion() {
    if (currentQuestionIndex >= allQuestions.length) return;
    
    final question = allQuestions[currentQuestionIndex];

    leftColumn = question.matchOptions.map((opt) => opt.leftText).toList();
    rightColumn = question.matchOptions.map((opt) => opt.rightText).toList()..shuffle();

    correctPairs = {
      for (var opt in question.matchOptions) opt.leftText: opt.rightText
    };

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

    selectedLeft = key;
    answerStates[key] = AnswerState.selected;

    notifyListeners();
    _checkPair();
  }

  void onRightTap(String item, int index) {
    String key = 'R:$item:$index';
    
    if (answerStates[key] == AnswerState.disabled ||
        answerStates[key] == AnswerState.correct) return;

    selectedRight = key;
    answerStates[key] = AnswerState.selected;

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

    if (isMatch) {
      answerStates[leftKey] = AnswerState.correct;
      answerStates[rightKey] = AnswerState.correct;

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));

      answerStates[leftKey] = AnswerState.disabled;
      answerStates[rightKey] = AnswerState.disabled;
    } else {
      answerStates[leftKey] = AnswerState.wrong;
      answerStates[rightKey] = AnswerState.wrong;

      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));

      answerStates[leftKey] = AnswerState.normal;
      answerStates[rightKey] = AnswerState.normal;
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

    if (currentQuestionIndex < allQuestions.length) {
      _loadCurrentQuestion();
    } else {
      notifyListeners();
    }
  }

  bool get isQuizFinished => 
      allQuestions.isNotEmpty && 
      currentQuestionIndex >= allQuestions.length;
}