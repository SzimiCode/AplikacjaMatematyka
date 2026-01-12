import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum DifficultyLevel { easy, medium, hard }

class FinalLearningViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  DifficultyLevel currentDifficulty = DifficultyLevel.easy;
  int streakCount = 0;
  
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  int questionNumber = 1;
  int maxQuestions = 10;
  
  bool isLoading = true;
  String? errorMessage;
  
  int totalCorrect = 0;
  int totalAnswered = 0;
  int fireReward = 0;
  
  int correctAnswersAtEasy = 0;
  int correctAnswersAtMedium = 0;
  int correctAnswersAtHard = 0;
  
  // 🔥 NOWE FLAGI: czy użytkownik UKOŃCZYŁ dany poziom (awansował dalej)?
  bool hasCompletedEasy = false;
  bool hasCompletedMedium = false;
  bool hasCompletedHard = false;
  
  dynamic currentAnswerData;
  bool isAnswerSubmitted = false;
  bool canSubmitAnswer = false;

  FinalLearningViewModel() {
    _initializeLearning();
  }

  Future<void> _initializeLearning() async {
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

      print('📚 Fetching questions for learning mode: ${selectedCourse.courseName}');
      
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

      allQuestions = [
        ...closedQuestions,
        ...yesnoQuestions,
        ...enterQuestions,
        ...matchQuestions,
      ];

      if (allQuestions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }
      
      allQuestions.shuffle();
      _loadNextQuestion();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadNextQuestion() {
    if (isLearningFinished) return;
    
    final difficultyName = _getDifficultyName();
    
    QuestionModel? nextQuestion;
    int searchIndex = currentQuestionIndex;
    
    while (searchIndex < allQuestions.length) {
      if (allQuestions[searchIndex].difficultyLevelName.toLowerCase() == 
          difficultyName.toLowerCase()) {
        nextQuestion = allQuestions[searchIndex];
        currentQuestionIndex = searchIndex;
        break;
      }
      searchIndex++;
    }
    
    if (nextQuestion == null && currentQuestionIndex < allQuestions.length) {
      nextQuestion = allQuestions[currentQuestionIndex];
    }
    
    if (nextQuestion != null) {
      isAnswerSubmitted = false;
      canSubmitAnswer = false;
      currentAnswerData = null;
      notifyListeners();
    }
  }

  String _getDifficultyName() {
    switch (currentDifficulty) {
      case DifficultyLevel.easy:
        return 'Easy';
      case DifficultyLevel.medium:
        return 'Medium';
      case DifficultyLevel.hard:
        return 'Hard';
    }
  }

  QuestionModel? get currentQuestion {
    if (allQuestions.isEmpty || currentQuestionIndex >= allQuestions.length) {
      return null;
    }
    return allQuestions[currentQuestionIndex];
  }

  String get currentQuestionType {
    return currentQuestion?.questionType ?? '';
  }

  double get progress {
    if (maxQuestions == 0) return 0.0;
    return (questionNumber - 1) / maxQuestions;
  }

  bool get isLearningFinished {
    if (_hasCompletedAllLevels()) {
      print('🎉 All levels completed! Early finish at question $questionNumber');
      return true;
    }
    
    if (questionNumber > maxQuestions) {
      if (currentDifficulty == DifficultyLevel.hard && streakCount > 0) {
        return false;
      }
      return true;
    }
    return false;
  }
  
  bool _hasCompletedAllLevels() {
    return hasCompletedEasy && hasCompletedMedium && hasCompletedHard;
  }

  bool get needsBonusQuestion {
    return questionNumber > maxQuestions && 
           streakCount > 0 && 
           currentDifficulty == DifficultyLevel.hard;
  }

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
      totalCorrect++;
      streakCount++;
      _incrementCorrectAnswerCounter();
      
      // 🔥 KLUCZOWA ZMIANA: Zapisz że poziom został ukończony PRZED awansem
      if (streakCount >= 3) {
        _markLevelAsCompleted();
        _levelUp();
        streakCount = 0;
      }
    } else {
      streakCount = 0;
    }
    
    notifyListeners();
  }
  
  void _incrementCorrectAnswerCounter() {
    switch (currentDifficulty) {
      case DifficultyLevel.easy:
        correctAnswersAtEasy++;
        break;
      case DifficultyLevel.medium:
        correctAnswersAtMedium++;
        break;
      case DifficultyLevel.hard:
        correctAnswersAtHard++;
        break;
    }
  }

  // 🔥 NOWA METODA: Oznacz poziom jako ukończony
  void _markLevelAsCompleted() {
    switch (currentDifficulty) {
      case DifficultyLevel.easy:
        hasCompletedEasy = true;
        print('🔥 Completed EASY level! Awarded fire.');
        break;
      case DifficultyLevel.medium:
        hasCompletedMedium = true;
        print('🔥 Completed MEDIUM level! Awarded fire.');
        break;
      case DifficultyLevel.hard:
        hasCompletedHard = true;
        print('🔥 Completed HARD level! Awarded fire.');
        break;
    }
  }

  void _levelUp() {
    if (currentDifficulty == DifficultyLevel.easy) {
      currentDifficulty = DifficultyLevel.medium;
      print('⬆️ Leveled up to MEDIUM');
    } else if (currentDifficulty == DifficultyLevel.medium) {
      currentDifficulty = DifficultyLevel.hard;
      print('⬆️ Leveled up to HARD');
    }
  }

  void moveToNextQuestion() {
    questionNumber++;
    currentQuestionIndex++;
    canSubmitAnswer = false;
    
    if (!isLearningFinished) {
      _loadNextQuestion();
    } else {
      _calculateFireReward();
    }
    
    notifyListeners();
  }

  void _calculateFireReward() {
    // Zlicz ile poziomów ukończono
    int completedLevels = 0;
    if (hasCompletedEasy) completedLevels++;
    if (hasCompletedMedium) completedLevels++;
    if (hasCompletedHard) completedLevels++;
    
    fireReward = completedLevels;
    
    print('🔥 Fire reward calculated: $fireReward fires');
    print('   Easy completed: $hasCompletedEasy');
    print('   Medium completed: $hasCompletedMedium');
    print('   Hard completed: $hasCompletedHard');
  }

  // 🔥 ZAPISZ POSTĘP NA BACKENDZIE - ZMIENIONA LOGIKA
  Future<void> saveLearningProgressToBackend() async {
    final selectedCourse = selectedCourseNotifier.value;
    if (selectedCourse == null) return;

    print('🔥 Saving learning progress to backend...');
    print('   Easy completed: $hasCompletedEasy');
    print('   Medium completed: $hasCompletedMedium');
    print('   Hard completed: $hasCompletedHard');

    final result = await _repository.saveLearningProgress(
      courseId: selectedCourse.id,
      fireEasy: hasCompletedEasy,    // 🔥 ZMIENIONE: zamiast correctAnswersAtEasy >= 3
      fireMedium: hasCompletedMedium, // 🔥 ZMIENIONE: zamiast correctAnswersAtMedium >= 3
      fireHard: hasCompletedHard,     // 🔥 ZMIENIONE: zamiast correctAnswersAtHard >= 3
    );

    if (result['success']) {
      final data = result['data'];
      print('✅ Progress saved!');
      print('   Fires added: ${data['fires_added']}');
      print('   Total points: ${data['total_points']}');
    } else {
      print('❌ Error saving progress: ${result['error']}');
    }
  }

  Future<void> restartLearning() async {
    currentDifficulty = DifficultyLevel.easy;
    streakCount = 0;
    currentQuestionIndex = 0;
    questionNumber = 1;
    totalCorrect = 0;
    totalAnswered = 0;
    fireReward = 0;
    isAnswerSubmitted = false;
    canSubmitAnswer = false;
    currentAnswerData = null;
    correctAnswersAtEasy = 0;
    correctAnswersAtMedium = 0;
    correctAnswersAtHard = 0;
    hasCompletedEasy = false;
    hasCompletedMedium = false;
    hasCompletedHard = false;
    
    await _initializeLearning();
  }

  void goToFinishPage() {
    saveLearningProgressToBackend();
    selectedPageNotifier.value = 12;
  }

  @override
  void dispose() {
    super.dispose();
  }
}