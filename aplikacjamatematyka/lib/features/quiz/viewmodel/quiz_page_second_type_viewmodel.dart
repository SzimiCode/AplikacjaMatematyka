import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class QuizPageSecondTypeViewModel extends ChangeNotifier {
  final CourseRepository _repository = CourseRepository();
  
  List<QuestionModel> allQuestions = [];
  int currentQuestionIndex = 0;
  final TextEditingController answerController = TextEditingController();

  QuizPageSecondTypeViewModel() {
    answerController.addListener(() {
      notifyListeners(); 
    });
    _initializeQuiz();
  }

  Future<void> _initializeQuiz() async {
    try {
      final selectedCourse = selectedCourseNotifier.value;
      
      if (selectedCourse == null) {
        return;
      }

      // pobieranie pytan typu 'yesno'
      final yesnoQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'yesno',
      );

      // pobieranie pytan typu 'enter'
      final enterQuestions = await _repository.getQuestions(
        courseId: selectedCourse.id,
        questionType: 'enter',
      );

      // Połącz obie listy
      allQuestions = [...yesnoQuestions, ...enterQuestions];
      
      // losowa kolejnosc pytan
      allQuestions.shuffle();
      
      notifyListeners();
    } catch (e) {
    }
  }

  String get currentQuestionText {
    if (allQuestions.isEmpty || currentQuestionIndex >= allQuestions.length) {
      return '';
    }
    return allQuestions[currentQuestionIndex].questionText;
  }

  bool get canConfirm => answerController.text.trim().isNotEmpty;

  void confirmAnswer() {
    if (!canConfirm) return;

    answerController.clear();
    currentQuestionIndex++;
    notifyListeners();
  }

  bool get isQuizFinished => currentQuestionIndex >= allQuestions.length;

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }
}