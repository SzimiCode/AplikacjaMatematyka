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
    return Column(
      children: [
        Text("Pytanie: "),
        const SizedBox(height: 30),
        AnswerButtonFirstType(text: 'Odpowiedz1', onTap: () {})
    ],
    );
  }
}