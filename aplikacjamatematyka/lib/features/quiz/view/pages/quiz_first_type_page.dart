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
  var currentQuestionIndex = 0;

  void answerQuestion() {
    setState(() {
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarQuizFirstTypeWidget(),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      currentQuestion.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ...currentQuestion
                        .getShuffledAnswersFirstType()
                        .map(
                          (answer) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AnswerButtonFirstType(
                              text: answer,
                              onTap: answerQuestion,
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 197, 70),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text("Sprawdź", 
                style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
