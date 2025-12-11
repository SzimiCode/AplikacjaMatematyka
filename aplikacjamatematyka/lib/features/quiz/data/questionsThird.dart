import 'package:aplikacjamatematyka/features/quiz/model/QuizQuestionThirdType.dart';

final questionsThird = [
  QuizQuestionThirdType(
  left: ['2 + 3', '4 × 2', '15 − 6', '9 ÷ 3'],
  right: ['5', '8', '9', '3'],
  correct: {
    '2 + 3': '5',
    '4 × 2': '8',
    '15 − 6': '9',
    '9 ÷ 3': '3',
  },
),
  QuizQuestionThirdType(
  left: ['1/2', '3/4', '2/3', '4/6'],
  right: ['2/4', '6/8', '4/6', '2/3'],
  correct: {
    '1/2': '2/4',
    '3/4': '6/8',
    '2/3': '4/6',
    '4/6': '2/3',
  },
)

];
