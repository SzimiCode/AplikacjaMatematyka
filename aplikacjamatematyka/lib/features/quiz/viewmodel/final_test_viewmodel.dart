import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class FinalTestViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  final int totalQuestions = 5;
  final int requiredToPass = 4;
  
  bool isLoading = true;
  String? errorMessage;
  
  int correctAnswersCount = 0;
  int totalAnswered = 0;
  
  bool isAnswerSubmitted = false;
  bool canSubmitAnswer = false;

  FinalTestViewModel() {
    _initializeTest();
  }

  Future<void> _initializeTest() async {
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
      
      final closedQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'closed',
      );
      
      final yesnoQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'yesno',
      );
      
      final enterQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'enter',
      );
      
      final matchQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'match',
      );

      List<QuestionModel> allAvailableQuestions = [
        ...closedQuestions,
        ...yesnoQuestions,
        ...enterQuestions,
        ...matchQuestions,
      ];

      if (allAvailableQuestions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }
      
      allAvailableQuestions.shuffle();
      allQuestions = allAvailableQuestions.take(totalQuestions).toList();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  QuestionModel? get currentQuestion {
    if (allQuestions.isEmpty || currentQuestionIndex >= allQuestions.length) {
      return null;
    }
    return allQuestions[currentQuestionIndex];
  }

  int get currentQuestionNumber => currentQuestionIndex + 1;

  double get progress {
    if (totalQuestions == 0) return 0.0;
    return currentQuestionIndex / totalQuestions;
  }

  bool get isTestFinished => currentQuestionIndex >= allQuestions.length;
  
  bool get hasPassed => correctAnswersCount >= requiredToPass;

  void onAnswerSelected() {
    canSubmitAnswer = true;
    notifyListeners();
  }
  
  void onAnswerSubmitted(bool isCorrect) {
    if (isAnswerSubmitted) return;
    
    isAnswerSubmitted = true;
    canSubmitAnswer = false;
    totalAnswered++;
    
    if (isCorrect) {
      correctAnswersCount++;
    }
    
    notifyListeners();
  }

  void moveToNextQuestion() {
    currentQuestionIndex++;
    canSubmitAnswer = false;
    isAnswerSubmitted = false;
    
    notifyListeners();
  }

  Future<void> saveQuizProgressToBackend() async {
    final selectedCourse = selectedCourseNotifier.value;
    if (selectedCourse == null) return;

    final result = await _repository.saveQuizProgress(
      courseId: selectedCourse.id,
      passed: hasPassed,
    );

    if (result['success']) {
      final data = result['data'];
    }
  }

  void goToPassedPage() {
    saveQuizProgressToBackend();
    selectedPageNotifier.value = 12;
  }

  void goToNotPassedPage() {
    selectedPageNotifier.value = 16;
  }

  Future<void> restartTest() async {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
    totalAnswered = 0;
    isAnswerSubmitted = false;
    canSubmitAnswer = false;
    
    await _initializeTest();
  }

  @override
  void dispose() {
    super.dispose();
  }
}