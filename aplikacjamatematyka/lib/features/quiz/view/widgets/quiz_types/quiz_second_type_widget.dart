import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';

class QuizSecondTypeWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(bool isCorrect) onAnswerSubmitted;
  final VoidCallback? onAnswerSelected;

  const QuizSecondTypeWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
    this.onAnswerSelected,
  });

  @override
  State<QuizSecondTypeWidget> createState() => QuizSecondTypeWidgetState(); // ✅ PUBLICZNA nazwa

}

class QuizSecondTypeWidgetState extends State<QuizSecondTypeWidget> { // ✅ BEZ underscore
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    answerController.addListener(() {
      setState(() {});
      if (answerController.text.trim().isNotEmpty) {
        widget.onAnswerSelected?.call();
      }
    });
  }

  @override
  void didUpdateWidget(QuizSecondTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      answerController.clear();
    }
  }

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  bool get isYesNoQuestion => widget.question.questionType == 'yesno';

  void selectYesNoAnswer(bool answer) {
    if (!isYesNoQuestion) return;
    
    setState(() {
      answerController.text = answer ? 'true' : 'false';
    });
    
    widget.onAnswerSelected?.call();
  }

  bool validateAndSubmit() {
    if (isYesNoQuestion) {
      if (answerController.text != 'true' && answerController.text != 'false') {
        return false;
      }
    } else {
      if (answerController.text.trim().isEmpty) {
        return false;
      }
    }

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

    print('📝 Second Type Answer: ${isCorrect ? "✅" : "❌"}');
    
    widget.onAnswerSubmitted(isCorrect);
    return true;
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
            
            if (isYesNoQuestion) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => selectYesNoAnswer(true),
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
                      onPressed: () => selectYesNoAnswer(false),
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
            
            if (!isYesNoQuestion) ...[
              TextField(
                controller: answerController,
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
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
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
              ),
            ],
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}