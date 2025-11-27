import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_second_type_page_viewmodel.dart';
import '../widgets/app_bar_quiz_first_type_widget.dart';

class QuizSecondTypePage extends StatelessWidget {
  const QuizSecondTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizSecondTypePageViewModel(),
      child: Consumer<QuizSecondTypePageViewModel>(
        builder: (context, vm, child) {
          if (vm.isQuizFinished) {
            return const Scaffold(
              body: Center(child: Text("Koniec quizu")),
            );
          }

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
                            vm.currentQuestionText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
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
}
