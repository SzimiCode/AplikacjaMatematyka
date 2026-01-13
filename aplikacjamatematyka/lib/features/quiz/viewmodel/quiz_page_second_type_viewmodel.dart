import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

enum AnswerState { normal, correct, wrong }

class QuizPageSecondTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();

  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();
  AnswerState answerState = AnswerState.normal;

  bool isLoading = true;
  String? errorMessage;

  int correctAnswersCount = 0;
  int totalAnswers = 0;

  QuizPageSecondTypeViewModel() {
    answerController.addListener(() {
      notifyListeners();
    });
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

      final yesnoQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'yesno',
      );

      final enterQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'enter',
      );

      allQuestions = [...yesnoQuestions, ...enterQuestions];

      if (allQuestions.isEmpty) {
        errorMessage = 'Brak pytań dla tego kursu';
        isLoading = false;
        notifyListeners();
        return;
      }

      allQuestions.shuffle();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Błąd podczas ładowania pytań: $e';
      isLoading = false;
      notifyListeners();
    }
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

  bool get isCurrentQuestionYesNo {
    final q = currentQuestion;
    if (q == null) return false;
    return q.questionType == 'yesno';
  }

  bool get canConfirm {
    if (isLoading) return false;

    if (isCurrentQuestionYesNo) {
      return answerController.text == 'true' ||
          answerController.text == 'false';
    }

    return answerController.text.trim().isNotEmpty;
  }

  void selectYesNoAnswer(bool answer) {
    if (!isCurrentQuestionYesNo) return;

    answerController.text = answer ? 'true' : 'false';
    notifyListeners();
  }

  void confirmAnswer() {
    if (!canConfirm) return;

    final currentQ = currentQuestion;
    if (currentQ == null) return;

    String userAnswer;
    String correctAnswer = currentQ.correctAnswer.toLowerCase().trim();

    if (isCurrentQuestionYesNo) {
      userAnswer = answerController.text.toLowerCase().trim();

      bool userBool = userAnswer == 'true';

      bool correctBool = correctAnswer == 'true' ||
          correctAnswer == 'tak' ||
          correctAnswer == 'yes' ||
          correctAnswer == '1';

      bool isCorrect = userBool == correctBool;

      if (isCorrect) {
        correctAnswersCount++;
        answerState = AnswerState.correct;
      } else {
        answerState = AnswerState.wrong;
      }
    } else {
      userAnswer =
          answerController.text.trim().toLowerCase().replaceAll(' ', '');
      correctAnswer = correctAnswer.replaceAll(' ', '');

      bool isCorrect = userAnswer == correctAnswer;

      if (isCorrect) {
        correctAnswersCount++;
        answerState = AnswerState.correct;
      } else {
        answerState = AnswerState.wrong;
      }
    }

    totalAnswers++;
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 700), () {
      answerState = AnswerState.normal;
      answerController.clear();
      currentQuestionIndex++;

      notifyListeners();
    });
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
    answerController.clear();
    answerState = AnswerState.normal;
    correctAnswersCount = 0;
    totalAnswers = 0;
    await _initializeQuiz();
  }

  void goToFinishQuiz() {
    selectedPageNotifier.value = 12;
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}
