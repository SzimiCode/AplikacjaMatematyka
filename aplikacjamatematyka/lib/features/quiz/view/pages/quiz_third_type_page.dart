import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_page_third_type_viewmodel.dart';
import '../widgets/buttons/answer_button_third_type.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class QuizThirdTypePage extends StatelessWidget {
  const QuizThirdTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizPageThirdTypeViewModel(),
      child: Consumer<QuizPageThirdTypeViewModel>(
        builder: (context, vm, child) {
          // Stan ładowania
          if (vm.isLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Ładowanie...'),
                backgroundColor: Colors.white,
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Stan błędu
          if (vm.errorMessage != null) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: QuizAppBar(  // ✅ UŻYWAJ TEGO SAMEGO AppBar co w działającym quizie
                progress: 0.0,
                isFinished: false,
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          selectedPageNotifier.value = 6;  // ✅ LUB jakakolwiek strona poprzednia
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 6, 197, 70),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Wróć',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Stan ukończenia quizu
          if (vm.isQuizFinished) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Wyniki'),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 80,
                        color: Color.fromARGB(255, 6, 197, 70),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Quiz ukończony!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Zdobyte punkty: ${vm.correctAnswersCount.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Liczba prób: ${vm.totalAnswers}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${vm.scorePercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 6, 197, 70),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'efektywności',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => vm.restartQuiz(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 6, 197, 70),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Spróbuj ponownie',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: Color.fromARGB(255, 6, 197, 70),
                            ),
                          ),
                          child: const Text(
                            'Wróć do kursu',
                            style: TextStyle(
                              color: Color.fromARGB(255, 6, 197, 70),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Stan normalny - quiz w trakcie
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.progress,
              isFinished: vm.isQuizFinished,
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Numer pytania
                          Text(
                            'Pytanie ${vm.currentQuestionIndex + 1} / ${vm.allQuestions.length}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
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
                          if (vm.allQuestions[vm.currentQuestionIndex].questionText.isNotEmpty) ...[
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
                          
                          // Kolumny dopasowania
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Lewa kolumna
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

                              // Prawa kolumna
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
                
                // Punktacja
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Punkty: ${vm.correctAnswersCount.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pozostało par: ${vm.remainingPairsInCurrentQuestion}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Przycisk "Dalej"
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 12, 35, 35),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.canConfirm ? vm.confirmAnswer : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vm.canConfirm
                            ? const Color.fromARGB(255, 6, 197, 70)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Dalej",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
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