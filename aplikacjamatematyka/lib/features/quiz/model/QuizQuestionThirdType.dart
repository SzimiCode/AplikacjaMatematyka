import 'package:aplikacjamatematyka/features/quiz/model/QuizQuestion.dart';

class QuizQuestionFirstType extends QuizQuestion {
  final String question;
  final List<String> answers;
  final String correct;

  QuizQuestionFirstType({
    required this.question,
    required this.answers,
    required this.correct,
  });

  @override
  QuizType get type => QuizType.single;
}
