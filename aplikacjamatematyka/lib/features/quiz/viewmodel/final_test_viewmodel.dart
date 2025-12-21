import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class FinalTestViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  // Pytania
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  final int totalQuestions = 5;
  final int requiredToPass = 4; // 4/5 żeby zdać
  
  // Stany
  bool isLoading = true;
  String? errorMessage;
  
  // Statystyki
  int correctAnswersCount = 0;
  int totalAnswered = 0;
  
  // Stan odpowiedzi
  bool isAnswerSelected = false;
  bool? lastAnswerCorrect;

  FinalTestViewModel() {
    _initializeTest();
  }

  // ========== INICJALIZACJA ==========
  
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

      print('📚 Fetching questions for test mode: ${selectedCourse.courseName}');
      
      // Pobierz pytania WSZYSTKICH typów
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

      // Połącz wszystkie pytania
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

      print('✅ Loaded ${allAvailableQuestions.length} available questions');
      
      // Wylosuj 5 pytań
      allAvailableQuestions.shuffle();
      allQuestions = allAvailableQuestions.take(totalQuestions).toList();
      
      print('📝 Selected ${allQuestions.length} questions for test');
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading questions: $e');
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // ========== GETTERY ==========
  
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

  // ========== OBSŁUGA ODPOWIEDZI ==========
  
  void onAnswerSelected(bool isCorrect) {
    if (isAnswerSelected) return;
    
    isAnswerSelected = true;
    lastAnswerCorrect = isCorrect;
    
    print('📊 Answer selected: ${isCorrect ? "✅ Correct" : "❌ Wrong"}');
    
    notifyListeners();
  }
  
  void submitAndContinue() {
    if (!isAnswerSelected || lastAnswerCorrect == null) return;
    
    totalAnswered++;
    
    if (lastAnswerCorrect!) {
      correctAnswersCount++;
    }
    
    print('   Current score: $correctAnswersCount/$totalAnswered');
    
    // Przejdź do następnego pytania
    currentQuestionIndex++;
    isAnswerSelected = false;
    lastAnswerCorrect = null;
    
    if (isTestFinished) {
      print('🎉 Test finished! Score: $correctAnswersCount/$totalQuestions');
      print('   Result: ${hasPassed ? "PASSED ✅" : "FAILED ❌"}');
    }
    
    notifyListeners();
  }

  // ========== NAWIGACJA ==========
  
  void goToPassedPage() {
    selectedPageNotifier.value = 13; // passed_test_page
  }

  void goToNotPassedPage() {
    selectedPageNotifier.value = 14; // not_passed_test_page
  }

  // ========== RESTART ==========
  
  Future<void> restartTest() async {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
    totalAnswered = 0;
    isAnswerSelected = false;
    lastAnswerCorrect = null;
    
    await _initializeTest();
  }

  @override
  void dispose() {
    super.dispose();
  }
}