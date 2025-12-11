import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_page_third_type_viewmodel.dart';
import '../widgets/buttons/answer_button_first_type.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/data/questionsThird.dart';

class QuizThirdTypePage extends StatelessWidget {
  const QuizThirdTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizPageThirdTypeViewModel(),
      child: Consumer<QuizPageThirdTypeViewModel>(
        builder: (context, vm, child) {
          if (vm.isQuizFinished) {
            return const Scaffold(
              body: Center(child: Text("Koniec quizu")),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.currentQuestionIndex / questionsThird.length,
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
                  
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Expanded(
                                child: Column(
                                  children: vm.leftColumn.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: AnswerButtonFirstType(
                                          text: item,
                                          isSelected: vm.selectedLeft == item,
                                          onTap: () => vm.onLeftTap(item),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(
                                child: Column(
                                  children: vm.rightColumn.map((item) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: AnswerButtonFirstType(
                                          text: item,
                                          isSelected: vm.selectedRight == item,
                                          onTap: () => vm.onRightTap(item),
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
