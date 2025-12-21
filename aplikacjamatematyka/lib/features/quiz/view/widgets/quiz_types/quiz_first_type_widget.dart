import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import '../buttons/answer_button_first_type.dart';

class QuizFirstTypeWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback? onAnswerSelected; // Nowy callback dla ViewModelu

  const QuizFirstTypeWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    this.onAnswerSelected,
  });

  @override
  State<QuizFirstTypeWidget> createState() => QuizFirstTypeWidgetState();
}

class QuizFirstTypeWidgetState extends State<QuizFirstTypeWidget> {
  String? selectedAnswer;
  List<String> shuffledAnswers = [];

  @override
  void initState() {
    super.initState();
    _shuffleAnswers();
  }

  @override
  void didUpdateWidget(QuizFirstTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      selectedAnswer = null;
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
    setState(() {
      selectedAnswer = answer;
    });
    widget.onAnswerSelected?.call(); // Powiadom ViewModel że coś wybrano
  }

  // Ta metoda będzie wywołana z zewnątrz (przez ViewModel) gdy user kliknie "Dalej"
  bool validateAndSubmit() {
    if (selectedAnswer == null) return false;

    final correctOption = widget.question.options.firstWhere(
      (option) => option.isCorrect,
      orElse: () => widget.question.options.first,
    );

    bool isCorrect = selectedAnswer == correctOption.optionText;
    
    print('📝 First Type Answer: ${isCorrect ? "✅" : "❌"}');
    
    widget.onAnswerSubmitted(isCorrect);
    return true;
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