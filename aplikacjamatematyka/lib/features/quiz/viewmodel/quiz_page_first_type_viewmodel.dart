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
  
  bool isLoading = true;
  String? errorMessage;
  
  int correctAnswersCount = 0;
  int totalAnswers = 0;

  QuizPageFirstTypeViewModel() {
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

      
      final questions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'closed',
      );

      if (questions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      allQuestions = questions;
      
      

      allQuestions.shuffle();
      

      _shuffleCurrentQuestionAnswers();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
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

  QuestionModel? get currentQuestion {
    if (allQuestions.isEmpty || currentQuestionIndex >= allQuestions.length) {
      return null;
    }
    return allQuestions[currentQuestionIndex];
  }


  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  bool get canConfirm => selectedAnswer != null && !isLoading;

  void confirmAnswer() {
    if (!canConfirm) return;

    final currentQ = currentQuestion;
    if (currentQ == null) return;

    final correctOption = currentQ.options.firstWhere(
      (option) => option.isCorrect,
      orElse: () => currentQ.options.first,
    );

    bool isCorrect = selectedAnswer == correctOption.optionText;
    
    if (isCorrect) {
      correctAnswersCount++;
      
    } else {

    }
    
    totalAnswers++;

    selectedAnswer = null;
    currentQuestionIndex++;
    
    if (currentQuestionIndex < allQuestions.length) {
      _shuffleCurrentQuestionAnswers();
    } 
    notifyListeners();
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
    if (totalAnswers == 0) return 0.0;
    return (correctAnswersCount / totalAnswers) * 100;
  }

  Future<void> restartQuiz() async {
    currentQuestionIndex = 0;
    selectedAnswer = null;
    correctAnswersCount = 0;
    totalAnswers = 0;
    await _initializeQuiz();
  }

  void goToFinishQuiz(){
    selectedPageNotifier.value = 12;
  }


  @override
  void dispose() {
    super.dispose();
  }
}