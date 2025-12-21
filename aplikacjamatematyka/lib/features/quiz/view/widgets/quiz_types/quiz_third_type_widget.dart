import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import '../buttons/answer_button_third_type.dart';

enum AnswerStateThird { normal, selected, correct, wrong, disabled }

class QuizThirdTypeWidget extends StatefulWidget {
  final QuestionModel question;
  final Function(bool isCorrect) onAnswerSubmitted;

  const QuizThirdTypeWidget({
    super.key,
    required this.question,
    required this.onAnswerSubmitted,
  });

  @override
  State<QuizThirdTypeWidget> createState() => _QuizThirdTypeWidgetState();
}

class _QuizThirdTypeWidgetState extends State<QuizThirdTypeWidget> {
  List<String> leftColumn = [];
  List<String> rightColumn = [];
  Map<String, String> correctPairs = {};

  String? selectedLeft;
  String? selectedRight;

  Map<String, AnswerStateThird> answerStates = {};
  
  double correctPairsCount = 0;
  int totalAttempts = 0;
  int totalPairs = 0;
  bool hasSubmitted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  @override
  void didUpdateWidget(QuizThirdTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _loadQuestion();
    }
  }

  void _loadQuestion() {
    leftColumn = widget.question.matchOptions
        .map((opt) => opt.leftText)
        .toList();
    
    rightColumn = widget.question.matchOptions
        .map((opt) => opt.rightText)
        .toList()
      ..shuffle();

    correctPairs = {
      for (var opt in widget.question.matchOptions)
        opt.leftText: opt.rightText
    };

    totalPairs = leftColumn.length;

    answerStates = {};
    for (int i = 0; i < leftColumn.length; i++) {
      answerStates['L:${leftColumn[i]}:$i'] = AnswerStateThird.normal;
    }
    for (int i = 0; i < rightColumn.length; i++) {
      answerStates['R:${rightColumn[i]}:$i'] = AnswerStateThird.normal;
    }

    selectedLeft = null;
    selectedRight = null;
    correctPairsCount = 0;
    totalAttempts = 0;
    hasSubmitted = false;

    setState(() {});
  }

  void onLeftTap(String item, int index) {
    if (hasSubmitted) return;
    
    String key = 'L:$item:$index';
    
    if (answerStates[key] == AnswerStateThird.disabled ||
        answerStates[key] == AnswerStateThird.correct) return;

    if (selectedLeft != null && selectedLeft != key) {
      if (answerStates[selectedLeft!] == AnswerStateThird.selected) {
        answerStates[selectedLeft!] = AnswerStateThird.normal;
      }
    }

    if (selectedLeft == key) {
      selectedLeft = null;
      answerStates[key] = AnswerStateThird.normal;
    } else {
      selectedLeft = key;
      answerStates[key] = AnswerStateThird.selected;
    }

    setState(() {});
    _checkPair();
  }

  void onRightTap(String item, int index) {
    if (hasSubmitted) return;
    
    String key = 'R:$item:$index';
    
    if (answerStates[key] == AnswerStateThird.disabled ||
        answerStates[key] == AnswerStateThird.correct) return;

    if (selectedRight != null && selectedRight != key) {
      if (answerStates[selectedRight!] == AnswerStateThird.selected) {
        answerStates[selectedRight!] = AnswerStateThird.normal;
      }
    }

    if (selectedRight == key) {
      selectedRight = null;
      answerStates[key] = AnswerStateThird.normal;
    } else {
      selectedRight = key;
      answerStates[key] = AnswerStateThird.selected;
    }

    setState(() {});
    _checkPair();
  }

  void _checkPair() async {
    if (selectedLeft == null || selectedRight == null) return;

    final leftKey = selectedLeft!;
    final rightKey = selectedRight!;
    
    final leftText = leftKey.split(':')[1];
    final rightText = rightKey.split(':')[1];

    final isMatch = correctPairs[leftText] == rightText;

    totalAttempts++;

    if (isMatch) {
      setState(() {
        answerStates[leftKey] = AnswerStateThird.correct;
        answerStates[rightKey] = AnswerStateThird.correct;
      });
      correctPairsCount++;
      
      print('✅ Correct match! (+1 point)');

      await Future.delayed(const Duration(milliseconds: 400));

      setState(() {
        answerStates[leftKey] = AnswerStateThird.disabled;
        answerStates[rightKey] = AnswerStateThird.disabled;
        selectedLeft = null;
        selectedRight = null;
      });

      // Sprawdź czy wszystkie pary dopasowane
      if (_allPairsMatched()) {
        _submitAnswer();
      }
    } else {
      setState(() {
        answerStates[leftKey] = AnswerStateThird.wrong;
        answerStates[rightKey] = AnswerStateThird.wrong;
      });
      
      if (correctPairsCount > 0) {
        correctPairsCount -= 0.5;
      }
      
      print('❌ Wrong match! (-0.5 points)');

      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        answerStates[leftKey] = AnswerStateThird.normal;
        answerStates[rightKey] = AnswerStateThird.normal;
        selectedLeft = null;
        selectedRight = null;
      });
    }
  }

  bool _allPairsMatched() {
    int matched = answerStates.values
        .where((s) => s == AnswerStateThird.disabled)
        .length ~/ 2;
    return matched == totalPairs;
  }

  void _submitAnswer() {
    if (hasSubmitted) return;
    
    setState(() {
      hasSubmitted = true;
    });

    // Oblicz czy to sukces
    // Zakładamy że sukces = wszystkie pary dopasowane
    bool isCorrect = _allPairsMatched();
    
    print('📝 Third Type Answer: ${isCorrect ? "✅" : "❌"}');
    print('   Pairs matched: $correctPairsCount/$totalPairs');
    
    widget.onAnswerSubmitted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instrukcja
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Dopasuj pary - kliknij element z lewej, potem odpowiadający z prawej',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Treść pytania (jeśli jest)
            if (widget.question.questionText.isNotEmpty) ...[
              Text(
                widget.question.questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Kolumny dopasowania
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lewa kolumna
                Expanded(
                  child: Column(
                    children: leftColumn.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      String key = 'L:$item:$index';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: AnswerButtonThirdType(
                            text: item,
                            onTap: () => onLeftTap(item, index),
                            isSelected: answerStates[key] == AnswerStateThird.selected,
                            isMatched: answerStates[key] == AnswerStateThird.correct ||
                                      answerStates[key] == AnswerStateThird.disabled,
                            isWrong: answerStates[key] == AnswerStateThird.wrong,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(width: 20),

                // Prawa kolumna
                Expanded(
                  child: Column(
                    children: rightColumn.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      String key = 'R:$item:$index';
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          width: double.infinity,
                          child: AnswerButtonThirdType(
                            text: item,
                            onTap: () => onRightTap(item, index),
                            isSelected: answerStates[key] == AnswerStateThird.selected,
                            isMatched: answerStates[key] == AnswerStateThird.correct ||
                                      answerStates[key] == AnswerStateThird.disabled,
                            isWrong: answerStates[key] == AnswerStateThird.wrong,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}