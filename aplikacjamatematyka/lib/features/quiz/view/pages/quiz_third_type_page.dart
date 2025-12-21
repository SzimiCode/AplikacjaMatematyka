import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_page_third_type_viewmodel.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/buttons/answer_button_third_type.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbars/appbar_quiz_widget.dart';

class QuizThirdTypePage extends StatelessWidget {
  const QuizThirdTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizPageThirdTypeViewModel(),
      child: Consumer<QuizPageThirdTypeViewModel>(
        builder: (context, vm, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.isQuizFinished) {
              vm.goToFinishQuiz();
            }
          });

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.allQuestions.isEmpty 
                  ? 0.0 
                  : vm.currentQuestionIndex / vm.allQuestions.length,
              isFinished: vm.isQuizFinished,
            ),
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
                          if (vm.allQuestions.isNotEmpty && 
                              vm.currentQuestionIndex < vm.allQuestions.length &&
                              vm.allQuestions[vm.currentQuestionIndex].questionText.isNotEmpty) ...[
                            Text(
                              vm.allQuestions[vm.currentQuestionIndex].questionText,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  children: vm.leftColumn.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String item = entry.value;
                                    String key = 'L:$item:$index';
                                    
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: AnswerButtonThirdType(
                                          text: item,
                                          onTap: () => vm.onLeftTap(item, index),
                                          isSelected: vm.answerStates[key] == AnswerState.selected,
                                          isMatched: vm.answerStates[key] == AnswerState.correct ||
                                                    vm.answerStates[key] == AnswerState.disabled,
                                          isWrong: vm.answerStates[key] == AnswerState.wrong,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: vm.rightColumn.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String item = entry.value;
                                    String key = 'R:$item:$index';
                                    
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: AnswerButtonThirdType(
                                          text: item,
                                          onTap: () => vm.onRightTap(item, index),
                                          isSelected: vm.answerStates[key] == AnswerState.selected,
                                          isMatched: vm.answerStates[key] == AnswerState.correct ||
                                                    vm.answerStates[key] == AnswerState.disabled,
                                          isWrong: vm.answerStates[key] == AnswerState.wrong,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.canConfirm ? vm.confirmAnswer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 6, 197, 70),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Dalej",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}