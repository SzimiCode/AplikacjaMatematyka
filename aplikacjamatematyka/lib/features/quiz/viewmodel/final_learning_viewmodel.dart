import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum DifficultyLevel { easy, medium, hard }

class FinalLearningViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  // Poziom trudności i progresja
  DifficultyLevel currentDifficulty = DifficultyLevel.easy;
  int streakCount = 0; // Kropki: 0-3
  
  // Pytania
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  int questionNumber = 1;
  int maxQuestions = 10;
  
  // Stany
  bool isLoading = true;
  String? errorMessage;
  
  // Statystyki
  int totalCorrect = 0;
  int totalAnswered = 0;
  int fireReward = 0; // Ile ogni dostanie na końcu
  
  // Stan obecnego pytania (dla różnych typów)
  dynamic currentAnswerData; // Może być String, bool, Map dla match
  bool isAnswerSubmitted = false;
  bool canSubmitAnswer = false; // NOWE: czy można kliknąć "Sprawdź"

  FinalLearningViewModel() {
    _initializeLearning();
  }

  // ========== INICJALIZACJA ==========
  
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

      print('✅ Loaded ${allQuestions.length} total questions');
      print('   - Closed: ${closedQuestions.length}');
      print('   - YesNo: ${yesnoQuestions.length}');
      print('   - Enter: ${enterQuestions.length}');
      print('   - Match: ${matchQuestions.length}');
      
      // Pomieszaj pytania
      allQuestions.shuffle();
      
      // Załaduj pierwsze pytanie (Easy)
      _loadNextQuestion();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading questions: $e');
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // ========== ŁADOWANIE PYTAŃ ==========
  
  void _loadNextQuestion() {
    if (isLearningFinished) return;
    
    // Znajdź pytanie odpowiednie dla obecnego poziomu trudności
    final difficultyName = _getDifficultyName();
    
    // Szukaj pytania z odpowiednim poziomem trudności
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
    
    // Jeśli nie znaleziono pytania tego poziomu, weź jakiekolwiek
    if (nextQuestion == null && currentQuestionIndex < allQuestions.length) {
      nextQuestion = allQuestions[currentQuestionIndex];
      print('⚠️ No $difficultyName question found, using any available');
    }
    
    if (nextQuestion != null) {
      print('📝 Loaded question ${questionNumber}: ${nextQuestion.questionType} - ${nextQuestion.difficultyLevelName}');
      isAnswerSubmitted = false;
      canSubmitAnswer = false; // Reset
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

  // ========== GETTERY ==========
  
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
    // Sprawdź czy osiągnięto maksymalną liczbę pytań
    if (questionNumber > maxQuestions) {
      // Jeśli trzeba bonus pytań (jest streak na Hard)
      if (currentDifficulty == DifficultyLevel.hard && streakCount > 0) {
        return false; // Kontynuuj bonusowe
      }
      return true;
    }
    return false;
  }

  bool get needsBonusQuestion {
    return questionNumber > maxQuestions && 
           streakCount > 0 && 
           currentDifficulty == DifficultyLevel.hard;
  }

  // ========== OBSŁUGA ODPOWIEDZI ==========
  
  // NOWA METODA: Wywołana gdy user wybierze odpowiedź (ale jeszcze nie kliknie "Sprawdź")
  void onAnswerSelected() {
    canSubmitAnswer = true;
    notifyListeners();
  }
  
  // ZMODYFIKOWANA: Wywołana gdy user kliknie "Sprawdź" i odpowiedź zostanie zwalidowana
  void onAnswerSubmitted(bool isCorrect) {
    if (isAnswerSubmitted) return;
    
    isAnswerSubmitted = true;
    canSubmitAnswer = false; // Reset
    totalAnswered++;
    
    print('📊 Answer submitted: ${isCorrect ? "✅ Correct" : "❌ Wrong"}');
    print('   Streak before: $streakCount');
    
    if (isCorrect) {
      totalCorrect++;
      streakCount++;
      
      // Sprawdź czy awans na wyższy poziom
      if (streakCount >= 3) {
        _levelUp();
        streakCount = 0;
      }
    } else {
      // Reset kropek przy błędzie
      streakCount = 0;
    }
    
    print('   Streak after: $streakCount');
    print('   Current difficulty: ${_getDifficultyName()}');
    
    notifyListeners();
  }

  void _levelUp() {
    if (currentDifficulty == DifficultyLevel.easy) {
      currentDifficulty = DifficultyLevel.medium;
      print('🎉 Level UP! → MEDIUM');
    } else if (currentDifficulty == DifficultyLevel.medium) {
      currentDifficulty = DifficultyLevel.hard;
      print('🎉 Level UP! → HARD');
    }
    // Hard jest najwyższy
  }

  // ZMODYFIKOWANA: Przejście do następnego pytania
  void moveToNextQuestion() {
    questionNumber++;
    currentQuestionIndex++;
    canSubmitAnswer = false; // Reset dla następnego pytania
    
    if (!isLearningFinished) {
      _loadNextQuestion();
    } else {
      _calculateFireReward();
    }
    
    notifyListeners();
  }

  void _calculateFireReward() {
    // Nagroda zależy od najwyższego osiągniętego poziomu
    switch (currentDifficulty) {
      case DifficultyLevel.easy:
        fireReward = 1;
        break;
      case DifficultyLevel.medium:
        fireReward = 2;
        break;
      case DifficultyLevel.hard:
        fireReward = 3;
        break;
    }
    
    print('🔥 Fire reward: $fireReward (level: ${_getDifficultyName()})');
  }

  // ========== RESTART ==========
  
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
    
    await _initializeLearning();
  }

  void goToFinishPage() {
    selectedPageNotifier.value = 12;
  }

  @override
  void dispose() {
    super.dispose();
  }
}