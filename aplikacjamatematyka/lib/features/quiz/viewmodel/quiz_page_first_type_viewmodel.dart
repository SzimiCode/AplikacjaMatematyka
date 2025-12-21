import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class QuizPageFirstTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<String> shuffledAnswers = [];

  QuizPageFirstTypeViewModel() {
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    try {
      final selectedCourse = selectedCourseNotifier.value;
      
      if (selectedCourse == null) {
        return;
      }

      final questions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'closed',
      );

      allQuestions = questions;
      allQuestions.shuffle();
      
      _shuffleCurrentQuestionAnswers();
      
      notifyListeners();
    } catch (e) {
    }
  }

  void _shuffleCurrentQuestionAnswers() {
    if (currentQuestionIndex >= allQuestions.length) return;
    
    final currentQuestion = allQuestions[currentQuestionIndex];
    
    shuffledAnswers = currentQuestion.options
        .map((option) => option.optionText)
        .toList()
      ..shuffle();
  }

  String get currentQuestionText {
    if (allQuestions.isEmpty || currentQuestionIndex >= allQuestions.length) {
      return '';
    }
    return allQuestions[currentQuestionIndex].questionText;
  }

  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  void goToFinishQuiz() {
    selectedPageNotifier.value = 12;
  }

  bool get canConfirm => selectedAnswer != null;

  void confirmAnswer() {
    if (!canConfirm) return;

    selectedAnswer = null;
    currentQuestionIndex++;
    
    if (currentQuestionIndex < allQuestions.length) {
      _shuffleCurrentQuestionAnswers();
    }
    
    notifyListeners();
  }

  bool get isQuizFinished => currentQuestionIndex >= allQuestions.length;
}