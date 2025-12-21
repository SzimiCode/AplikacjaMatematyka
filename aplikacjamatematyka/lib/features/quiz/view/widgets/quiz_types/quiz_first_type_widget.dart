import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import '../buttons/answer_button_first_type.dart';

class QuizFirstTypeWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(bool isCorrect) onAnswerSubmitted;

  const QuizFirstTypeWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
  });

  @override
  State<QuizFirstTypeWidget> createState() => _QuizFirstTypeWidgetState();
}

class _QuizFirstTypeWidgetState extends State<QuizFirstTypeWidget> {
  String? selectedAnswer;
  List<String> shuffledAnswers = [];
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _shuffleAnswers();
  }

  @override
  void didUpdateWidget(QuizFirstTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jeśli pytanie się zmieniło, zresetuj stan
    if (oldWidget.question.id != widget.question.id) {
      selectedAnswer = null;
      hasSubmitted = false;
      _shuffleAnswers();
    }
  }

  void _shuffleAnswers() {
    shuffledAnswers = widget.question.options
        .map((option) => option.optionText)
        .toList()
      ..shuffle();
  }

  void _selectAnswer(String answer) {
    if (hasSubmitted) return;
    setState(() {
      selectedAnswer = answer;
    });
    _submitAnswer();
  }

  void _submitAnswer() {
    if (hasSubmitted || selectedAnswer == null) return;

    final correctOption = widget.question.options.firstWhere(
      (option) => option.isCorrect,
      orElse: () => widget.question.options.first,
    );

    bool isCorrect = selectedAnswer == correctOption.optionText;
    
    setState(() {
      hasSubmitted = true;
    });

    print('📝 First Type Answer: ${isCorrect ? "✅" : "❌"}');
    
    // Callback do ViewModelu
    widget.onAnswerSubmitted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Treść pytania
            Text(
              widget.question.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // Przyciski odpowiedzi
            ...shuffledAnswers.map((answer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerButtonFirstType(
                text: answer,
                isSelected: selectedAnswer == answer,
                onTap: () => _selectAnswer(answer),
              ),
            )),
          ],
        ),
      ),
    );
  }
}