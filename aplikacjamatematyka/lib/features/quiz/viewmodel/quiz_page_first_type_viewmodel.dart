import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class QuizPageFirstTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  // Stan pytań i quizu
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<String> shuffledAnswers = [];
  
  // Stany ładowania i błędów
  bool isLoading = true;
  String? errorMessage;
  
  // Statystyki
  int correctAnswersCount = 0;
  int totalAnswers = 0;

  QuizPageFirstTypeViewModel() {
    _initializeQuiz();
  }

  // Inicjalizacja quizu - pobieranie pytań dla wybranego kursu
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

      print('📚 Fetching questions for course: ${selectedCourse.courseName}');
      
      // Pobierz pytania typu 'closed' dla wybranego kursu
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
      print('✅ Loaded ${allQuestions.length} questions');
      
      // Pomieszaj kolejność pytań
      allQuestions.shuffle();
      
      // Przygotuj pierwsze pytanie
      _shuffleCurrentQuestionAnswers();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading questions: $e');
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // Pomieszaj odpowiedzi dla obecnego pytania
  void _shuffleCurrentQuestionAnswers() {
    if (currentQuestionIndex >= allQuestions.length) return;
    
    final currentQuestion = allQuestions[currentQuestionIndex];
    
    // Pobierz wszystkie opcje odpowiedzi i pomieszaj je
    shuffledAnswers = currentQuestion.options
        .map((option) => option.optionText)
        .toList()
      ..shuffle();
  }

  // Gettery dla obecnego pytania
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

  // Wybór odpowiedzi
  void selectAnswer(String answer) {
    selectedAnswer = answer;
    notifyListeners();
  }

  // Sprawdź czy można potwierdzić odpowiedź
  bool get canConfirm => selectedAnswer != null && !isLoading;

  // Potwierdź odpowiedź i przejdź dalej
  void confirmAnswer() {
    if (!canConfirm) return;

    final currentQ = currentQuestion;
    if (currentQ == null) return;

    // Sprawdź czy odpowiedź jest poprawna
    final correctOption = currentQ.options.firstWhere(
      (option) => option.isCorrect,
      orElse: () => currentQ.options.first,
    );

    bool isCorrect = selectedAnswer == correctOption.optionText;
    
    if (isCorrect) {
      correctAnswersCount++;
      print('✅ Correct answer!');
    } else {
      print('❌ Wrong answer. Correct was: ${correctOption.optionText}');
    }
    
    totalAnswers++;

    // Reset wyboru i przejdź do następnego pytania
    selectedAnswer = null;
    currentQuestionIndex++;
    
    if (currentQuestionIndex < allQuestions.length) {
      _shuffleCurrentQuestionAnswers();
    } else {
      print('🎉 Quiz finished! Score: $correctAnswersCount/$totalAnswers');
    }
    
    notifyListeners();
  }

  // Sprawdź czy quiz się skończył
  bool get isQuizFinished => 
      !isLoading && 
      allQuestions.isNotEmpty && 
      currentQuestionIndex >= allQuestions.length;

  // Postęp w quizie (0.0 - 1.0)
  double get progress {
    if (allQuestions.isEmpty) return 0.0;
    return currentQuestionIndex / allQuestions.length;
  }

  // Procent poprawnych odpowiedzi
  double get scorePercentage {
    if (totalAnswers == 0) return 0.0;
    return (correctAnswersCount / totalAnswers) * 100;
  }

  // Restart quizu
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