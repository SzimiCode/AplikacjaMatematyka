import 'package:aplikacjamatematyka/features/quiz/data/questions.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/answer_button_first_type.dart';
import 'package:flutter/material.dart';
class QuizFirstTypePage extends StatefulWidget {
  const QuizFirstTypePage({super.key});

  @override
  State<QuizFirstTypePage> createState() => _QuizFirstTypePageState();
}

class _QuizFirstTypePageState extends State<QuizFirstTypePage> {
  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[0];
    return Column(
     mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(currentQuestion.text),
        const SizedBox(height: 30),
        //musi być to list bo mapa potrzebuje, a 3 kropki to spread operator. Rozyspuje liste widgetow na zewnatrz do innej listy
         ...currentQuestion.answers.map((answer) {
        return AnswerButtonFirstType(
        text: answer,
        onTap: () {
          
        },
      );
    }).toList(),
    ],
    );
  }
}