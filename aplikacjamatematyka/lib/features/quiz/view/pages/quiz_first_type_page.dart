import 'package:aplikacjamatematyka/features/quiz/data/questions.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/answer_button_first_type.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/app_bar_quiz_first_type_widget.dart';
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
    return Scaffold(
          backgroundColor: const Color.fromARGB(255, 165, 12, 192),
          appBar: AppBarQuizFirstTypeWidget(),
          body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  left: 35,
                  right: 35,
                  bottom: 35,
                ),
                child: Column(
                  
                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      currentQuestion.text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )
                      ),
                    const SizedBox(height: 30),
                    //musi być to list bo mapa potrzebuje, a 3 kropki to spread operator. Rozyspuje liste widgetow na zewnatrz do innej listy
                    ...currentQuestion.getShuffledAnswersFirstType().map((answer) {
                    return AnswerButtonFirstType(
                    text: answer,
                    onTap: () {
                      
                    },
                  );
                }).toList(),
                ],
                ),
              ),
            ],
          ),
    );
  
  }
}