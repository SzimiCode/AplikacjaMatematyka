import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/final_test_viewmodel.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_first_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_second_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_third_type_widget.dart';

class FinalTestPage extends StatelessWidget {
  const FinalTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalTestViewModel(),
      child: Consumer<FinalTestViewModel>(
        builder: (context, vm, child) {
          // Stan ładowania
          if (vm.isLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Ładowanie testu...'),
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
              appBar: QuizAppBar(
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
                          selectedPageNotifier.value = 6;
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

          // Stan ukończenia testu
          if (vm.isTestFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (vm.hasPassed) {
                vm.goToPassedPage();
              } else {
                vm.goToNotPassedPage();
              }
            });
            
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Stan normalny - test w trakcie
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.progress,
              isFinished: vm.isTestFinished,
            ),
            body: Column(
              children: [
                _buildTestHeader(vm),
                Expanded(
                  child: _buildQuestionWidget(vm),
                ),
                _buildNextButton(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  // ========== HEADER Z NUMEREM PYTANIA ==========
  
  Widget _buildTestHeader(FinalTestViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        children: [
          // Etykieta "TEST"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'TEST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Numer pytania
          Text(
            'Pytanie ${vm.currentQuestionNumber} / ${vm.totalQuestions}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Aktualny wynik
          Text(
            'Wynik: ${vm.correctAnswersCount}/${vm.totalAnswered}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ========== DYNAMICZNY WIDGET PYTANIA ==========
  
  Widget _buildQuestionWidget(FinalTestViewModel vm) {
    final question = vm.currentQuestion;
    
    if (question == null) {
      return const Center(child: Text('Brak pytania'));
    }

    switch (question.questionType) {
      case 'closed':
        return QuizFirstTypeWidget(
          key: ValueKey(question.id),
          question: question,
          onAnswerSelected: (isCorrect) => vm.onAnswerSelected(isCorrect),
        );
      
      case 'yesno':
      case 'enter':
        return QuizSecondTypeWidget(
          key: ValueKey(question.id),
          question: question,
          onAnswerSelected: (isCorrect) => vm.onAnswerSelected(isCorrect),
        );
      
      case 'match':
        return QuizThirdTypeWidget(
          key: ValueKey(question.id),
          question: question,
          onAnswerSelected: (isCorrect) => vm.onAnswerSelected(isCorrect),
        );
      
      default:
        return Center(child: Text('Nieznany typ: ${question.questionType}'));
    }
  }

  // ========== PRZYCISK DALEJ ==========
  
  Widget _buildNextButton(FinalTestViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 12, 35, 35),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: vm.isAnswerSelected ? () => vm.submitAndContinue() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: vm.isAnswerSelected
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
    );
  }
}