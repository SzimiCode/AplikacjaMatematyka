import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum AnswerState { normal, correct, wrong }

class QuizPageSecondTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  // Stan pytań i quizu
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();
  AnswerState answerState = AnswerState.normal;
  
  // Stany ładowania i błędów
  bool isLoading = true;
  String? errorMessage;
  
  // Statystyki
  int correctAnswersCount = 0;
  int totalAnswers = 0;

  QuizPageSecondTypeViewModel() {
    answerController.addListener(() {
      notifyListeners(); 
    });
    _initializeQuiz();
  }

  // Inicjalizacja quizu - pobieranie pytań yesno i enter
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

      print('📚 Fetching yesno and enter questions for course: ${selectedCourse.courseName}');
      
      // Pobierz pytania typu 'yesno'
      print('🔍 Fetching YESNO questions...');
      final yesnoQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'yesno',
      );
      print('🔍 YESNO count: ${yesnoQuestions.length}');

      // Pobierz pytania typu 'enter'
      print('🔍 Fetching ENTER questions...');
      final enterQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'enter',
      );
      print('🔍 ENTER count: ${enterQuestions.length}');

      // Połącz obie listy
      allQuestions = [...yesnoQuestions, ...enterQuestions];
      print('🔍 Total combined: ${allQuestions.length}');

      if (allQuestions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      print('✅ Loaded ${allQuestions.length} questions (${yesnoQuestions.length} yesno + ${enterQuestions.length} enter)');
      
      // Pomieszaj kolejność pytań
      allQuestions.shuffle();
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading questions: $e');
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
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

  // Czy obecne pytanie to yesno czy enter
  bool get isCurrentQuestionYesNo {
    final q = currentQuestion;
    if (q == null) return false;
    return q.questionType == 'yesno';
  }

  // Sprawdź czy można potwierdzić
  bool get canConfirm {
    if (isLoading) return false;
    
    // Dla yesno sprawdź czy wybrano true lub false
    if (isCurrentQuestionYesNo) {
      return answerController.text == 'true' || answerController.text == 'false';
    }
    
    // Dla enter musi być wpisany tekst
    return answerController.text.trim().isNotEmpty;
  }

  // Wybór odpowiedzi Tak/Nie (dla yesno)
  void selectYesNoAnswer(bool answer) {
    if (!isCurrentQuestionYesNo) return;
    
    answerController.text = answer ? 'true' : 'false';
    notifyListeners();
  }

  // Potwierdź odpowiedź
  void confirmAnswer() {
    if (!canConfirm) return;

    final currentQ = currentQuestion;
    if (currentQ == null) return;

    String userAnswer;
    String correctAnswer = currentQ.correctAnswer.toLowerCase().trim();

    if (isCurrentQuestionYesNo) {
      // Dla yesno konwertujemy na boolean i porównujemy
      userAnswer = answerController.text.toLowerCase().trim();
      
      // Konwertuj user answer na boolean
      bool userBool = userAnswer == 'true';
      
      // Konwertuj correct answer na boolean (obsługa różnych formatów)
      bool correctBool = correctAnswer == 'true' || 
                        correctAnswer == 'tak' || 
                        correctAnswer == 'yes' ||
                        correctAnswer == '1';
      
      print('🔍 YESNO check: user=$userBool, correct=$correctBool (raw: "$correctAnswer")');
      
      bool isCorrect = userBool == correctBool;
      
      if (isCorrect) {
        correctAnswersCount++;
        answerState = AnswerState.correct;
        print('✅ Correct answer!');
      } else {
        answerState = AnswerState.wrong;
        print('❌ Wrong answer. Correct was: ${currentQ.correctAnswer}');
      }
    } else {
      // Dla enter normalizujemy odpowiedź
      userAnswer = answerController.text.trim().toLowerCase().replaceAll(' ', '');
      correctAnswer = correctAnswer.replaceAll(' ', '');
      
      bool isCorrect = userAnswer == correctAnswer;
      
      if (isCorrect) {
        correctAnswersCount++;
        answerState = AnswerState.correct;
        print('✅ Correct answer!');
      } else {
        answerState = AnswerState.wrong;
        print('❌ Wrong answer. Correct was: ${currentQ.correctAnswer}');
      }
    }
    
    totalAnswers++;
    notifyListeners();

    // Po krótkiej chwili przejdź do następnego pytania
    Future.delayed(const Duration(milliseconds: 700), () {
      answerState = AnswerState.normal;
      answerController.clear();
      currentQuestionIndex++;
      
      if (currentQuestionIndex >= allQuestions.length) {
        print('🎉 Quiz finished! Score: $correctAnswersCount/$totalAnswers');
      }
      
      notifyListeners();
    });
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
    answerController.clear();
    answerState = AnswerState.normal;
    correctAnswersCount = 0;
    totalAnswers = 0;
    await _initializeQuiz();
  }


  void goToFinishQuiz(){
    selectedPageNotifier.value = 12;
  }


  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}