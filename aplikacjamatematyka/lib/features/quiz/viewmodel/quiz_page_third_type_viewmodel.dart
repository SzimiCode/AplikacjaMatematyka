import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum AnswerState { normal, selected, correct, wrong, disabled }

class QuizPageThirdTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  // Stan pytań i quizu
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;

  // Kolumny dopasowania
  List<String> leftColumn = [];
  List<String> rightColumn = [];
  Map<String, String> correctPairs = {};

  String? selectedLeft;
  String? selectedRight;

  // Używamy unikalnych kluczy: "L:tekst" dla lewej, "R:tekst" dla prawej
  Map<String, AnswerState> answerStates = {};
  
  // Stany ładowania i błędów
  bool isLoading = true;
  String? errorMessage;
  
  // Statystyki
  double correctAnswersCount = 0; // Zmienione na double dla -0.5
  int totalAnswers = 0;
  int totalPairsInCurrentQuestion = 0;

  QuizPageThirdTypeViewModel() {
    _initializeQuiz();
  }

  // Inicjalizacja quizu - pobieranie pytań match
  Future<void> _initializeQuiz() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final selectedCourse = selectedCourseNotifier.value;
      
      print('🔍 DEBUG: selectedCourse = $selectedCourse');
      print('🔍 DEBUG: selectedCourse?.id = ${selectedCourse?.id}');
      
      if (selectedCourse == null) {
        errorMessage = 'Nie wybrano kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      print('📚 Fetching match questions for course: ${selectedCourse.courseName}');
      
      // Pobierz pytania typu 'match'
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
      print('✅ Loaded ${allQuestions.length} match questions');
      
      // Pomieszaj kolejność pytań
      allQuestions.shuffle();
      
      isLoading = false;
      
      // Załaduj pierwsze pytanie
      _loadCurrentQuestion();
      
    } catch (e) {
      print('❌ Error loading questions: $e');
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  void _loadCurrentQuestion() {
    if (currentQuestionIndex >= allQuestions.length) return;
    
    final question = allQuestions[currentQuestionIndex];
    
    print('📝 Loading question ${currentQuestionIndex + 1}: ${question.questionText}');
    print('   Match options count: ${question.matchOptions.length}');

    // Przygotuj kolumny z matchOptions
    leftColumn = question.matchOptions
        .map((opt) => opt.leftText)
        .toList();
    
    rightColumn = question.matchOptions
        .map((opt) => opt.rightText)
        .toList()
      ..shuffle(); // Pomieszaj prawą kolumnę

    // Przygotuj mapę poprawnych par
    correctPairs = {
      for (var opt in question.matchOptions)
        opt.leftText: opt.rightText
    };

    totalPairsInCurrentQuestion = leftColumn.length;

    // Reset stanów - UNIKALNE KLUCZE
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
    
    // Nie można klikać już dopasowanych
    if (answerStates[key] == AnswerState.disabled ||
        answerStates[key] == AnswerState.correct) return;

    // Odznacz poprzedni wybór z lewej strony
    if (selectedLeft != null && selectedLeft != key) {
      if (answerStates[selectedLeft!] == AnswerState.selected) {
        answerStates[selectedLeft!] = AnswerState.normal;
      }
    }

    // Jeśli kliknięto ten sam - odznacz
    if (selectedLeft == key) {
      selectedLeft = null;
      answerStates[key] = AnswerState.normal;
    } else {
      // Zaznacz nowy
      selectedLeft = key;
      answerStates[key] = AnswerState.selected;
    }

    notifyListeners();
    _checkPair();
  }

  void onRightTap(String item, int index) {
    String key = 'R:$item:$index';
    
    // Nie można klikać już dopasowanych
    if (answerStates[key] == AnswerState.disabled ||
        answerStates[key] == AnswerState.correct) return;

    // Odznacz poprzedni wybór z prawej strony
    if (selectedRight != null && selectedRight != key) {
      if (answerStates[selectedRight!] == AnswerState.selected) {
        answerStates[selectedRight!] = AnswerState.normal;
      }
    }

    // Jeśli kliknięto ten sam - odznacz
    if (selectedRight == key) {
      selectedRight = null;
      answerStates[key] = AnswerState.normal;
    } else {
      // Zaznacz nowy - POPRAWKA: używaj klucza zamiast tekstu
      selectedRight = key;
      answerStates[key] = AnswerState.selected;
    }

    notifyListeners();
    _checkPair();
  }

  void _checkPair() async {
    // Sprawdź dopiero jak wybrano OBA
    if (selectedLeft == null || selectedRight == null) return;

    final leftKey = selectedLeft!;
    final rightKey = selectedRight!;
    
    // Wyciągnij rzeczywiste teksty z kluczy
    // leftKey = "L:tekst:index" -> "tekst"
    // rightKey = "R:tekst:index" -> "tekst"
    final leftText = leftKey.split(':')[1];
    final rightText = rightKey.split(':')[1];

    final isMatch = correctPairs[leftText] == rightText;

    print('🔍 Checking pair: "$leftText" -> "$rightText"');
    print('   Expected: "$leftText" -> "${correctPairs[leftText]}"');
    print('   Match: $isMatch');

    totalAnswers++;

    if (isMatch) {
      // Poprawna para → +1 punkt, zielone i blokada
      answerStates[leftKey] = AnswerState.correct;
      answerStates[rightKey] = AnswerState.correct;
      correctAnswersCount++;
      
      print('✅ Correct pair! (+1 point)');

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 400));

      answerStates[leftKey] = AnswerState.disabled;
      answerStates[rightKey] = AnswerState.disabled;
      
      // Reset wyborów
      selectedLeft = null;
      selectedRight = null;
    } else {
      // Niepoprawna para → -0.5 punktu, czerwone, reset ale można próbować dalej
      answerStates[leftKey] = AnswerState.wrong;
      answerStates[rightKey] = AnswerState.wrong;
      
      // Kara za błąd (ale nie można zejść poniżej 0)
      if (correctAnswersCount > 0) {
        correctAnswersCount -= 0.5;
      }
      
      print('❌ Wrong pair! (-0.5 points)');

      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 800));

      // Reset do normal - można próbować dalej
      answerStates[leftKey] = AnswerState.normal;
      answerStates[rightKey] = AnswerState.normal;
      
      // Reset wyborów
      selectedLeft = null;
      selectedRight = null;
    }

    notifyListeners();
  }

  // Można przejść dalej gdy wszystkie pary dopasowane
  bool get canConfirm =>
      answerStates.values.where((s) => s == AnswerState.disabled).length ==
      leftColumn.length * 2;

  void confirmAnswer() {
    currentQuestionIndex++;

    if (currentQuestionIndex < allQuestions.length) {
      _loadCurrentQuestion();
    } else {
      print('🎉 Quiz finished! Correct pairs: $correctAnswersCount/$totalAnswers');
      notifyListeners();
    }
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

  // Procent poprawnych odpowiedzi (liczone względem maksymalnych punktów)
  double get scorePercentage {
    // Maksymalne punkty = liczba par w całym quizie
    int maxPossiblePairs = allQuestions.fold(0, (sum, q) => sum + q.matchOptions.length);
    if (maxPossiblePairs == 0) return 0.0;
    
    // Procent z maksymalnych możliwych punktów
    return (correctAnswersCount / maxPossiblePairs) * 100;
  }
  
  // Ile par zostało do dopasowania w obecnym pytaniu
  int get remainingPairsInCurrentQuestion {
    int matched = answerStates.values.where((s) => s == AnswerState.disabled).length ~/ 2;
    return totalPairsInCurrentQuestion - matched;
  }

  // Restart quizu
  Future<void> restartQuiz() async {
    currentQuestionIndex = 0;
    correctAnswersCount = 0;
    totalAnswers = 0;
    await _initializeQuiz();
  }

void goToFinishQuiz(){
    selectedPageNotifier.value = 12;
  }


}