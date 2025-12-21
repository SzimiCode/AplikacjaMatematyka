import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';

enum AnswerStateWidget { normal, correct, wrong }

class QuizSecondTypeWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(bool isCorrect) onAnswerSubmitted;

  const QuizSecondTypeWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
  });

  @override
  State<QuizSecondTypeWidget> createState() => _QuizSecondTypeWidgetState();
}

class _QuizSecondTypeWidgetState extends State<QuizSecondTypeWidget> {
  final TextEditingController answerController = TextEditingController();
  AnswerStateWidget answerState = AnswerStateWidget.normal;
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    answerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(QuizSecondTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Jeśli pytanie się zmieniło, zresetuj stan
    if (oldWidget.question.id != widget.question.id) {
      answerController.clear();
      answerState = AnswerStateWidget.normal;
      hasSubmitted = false;
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  bool get isYesNoQuestion => widget.question.questionType == 'yesno';

  bool get canSubmit {
    if (hasSubmitted) return false;
    
    if (isYesNoQuestion) {
      return answerController.text == 'true' || answerController.text == 'false';
    }
    
    return answerController.text.trim().isNotEmpty;
  }

  void selectYesNoAnswer(bool answer) {
    if (!isYesNoQuestion || hasSubmitted) return;
    
    setState(() {
      answerController.text = answer ? 'true' : 'false';
    });
    
    // Auto-submit dla yes/no
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && canSubmit) {
        _submitAnswer();
      }
    });
  }

  void _submitAnswer() {
    if (!canSubmit) return;

    String userAnswer;
    String correctAnswer = widget.question.correctAnswer.toLowerCase().trim();
    bool isCorrect;

    if (isYesNoQuestion) {
      userAnswer = answerController.text.toLowerCase().trim();
      bool userBool = userAnswer == 'true';
      bool correctBool = correctAnswer == 'true' || 
                        correctAnswer == 'tak' || 
                        correctAnswer == 'yes' ||
                        correctAnswer == '1';
      
      isCorrect = userBool == correctBool;
    } else {
      userAnswer = answerController.text.trim().toLowerCase().replaceAll(' ', '');
      correctAnswer = correctAnswer.replaceAll(' ', '');
      isCorrect = userAnswer == correctAnswer;
    }

    setState(() {
      hasSubmitted = true;
      answerState = isCorrect ? AnswerStateWidget.correct : AnswerStateWidget.wrong;
    });

    print('📝 Second Type Answer: ${isCorrect ? "✅" : "❌"}');
    
    // Krótkie opóźnienie żeby pokazać stan
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        widget.onAnswerSubmitted(isCorrect);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Typ pytania
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isYesNoQuestion 
                    ? Colors.blue.shade50 
                    : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isYesNoQuestion ? 'TAK/NIE' : 'WPISZ ODPOWIEDŹ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isYesNoQuestion 
                      ? Colors.blue.shade700 
                      : Colors.orange.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
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
            
            // YESNO - guziki Tak/Nie
            if (isYesNoQuestion) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hasSubmitted ? null : () => selectYesNoAnswer(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answerController.text == 'true'
                            ? const Color.fromARGB(255, 6, 197, 70)
                            : Colors.grey.shade200,
                        foregroundColor: answerController.text == 'true'
                            ? Colors.white
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'TAK',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hasSubmitted ? null : () => selectYesNoAnswer(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: answerController.text == 'false'
                            ? const Color.fromARGB(255, 6, 197, 70)
                            : Colors.grey.shade200,
                        foregroundColor: answerController.text == 'false'
                            ? Colors.white
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'NIE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // ENTER - TextField
            if (!isYesNoQuestion) ...[
              TextField(
                controller: answerController,
                enabled: !hasSubmitted,
                minLines: 4,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: answerState == AnswerStateWidget.correct
                          ? Colors.green
                          : answerState == AnswerStateWidget.wrong
                              ? Colors.red
                              : Colors.grey,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: answerState == AnswerStateWidget.correct
                          ? Colors.green
                          : answerState == AnswerStateWidget.wrong
                              ? Colors.red
                              : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 6, 197, 70),
                      width: 2,
                    ),
                  ),
                  hintText: "Wpisz swoją odpowiedź...",
                ),
                onSubmitted: (_) => _submitAnswer(),
              ),
              const SizedBox(height: 12),
              // Przycisk "Sprawdź" dla ENTER
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canSubmit ? _submitAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSubmit
                        ? const Color.fromARGB(255, 6, 197, 70)
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Sprawdź",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Wskaźnik poprawności (po odpowiedzi)
            if (answerState != AnswerStateWidget.normal) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: answerState == AnswerStateWidget.correct
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      answerState == AnswerStateWidget.correct
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: answerState == AnswerStateWidget.correct
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      answerState == AnswerStateWidget.correct
                          ? 'Poprawna odpowiedź!'
                          : 'Niepoprawna odpowiedź',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: answerState == AnswerStateWidget.correct
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}