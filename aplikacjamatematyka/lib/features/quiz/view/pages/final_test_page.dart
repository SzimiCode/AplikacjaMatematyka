import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/final_test_viewmodel.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_first_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_second_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_third_type_widget.dart';

class FinalTestPage extends StatefulWidget {
  const FinalTestPage({super.key});

  @override
  State<FinalTestPage> createState() => _FinalTestPageState();
}

class _FinalTestPageState extends State<FinalTestPage> {
  final GlobalKey<QuizFirstTypeWidgetState> _firstTypeKey = GlobalKey();
  final GlobalKey<QuizSecondTypeWidgetState> _secondTypeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalTestViewModel(),
      child: Consumer<FinalTestViewModel>(
        builder: (context, vm, child) {
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
          
          Text(
            'Pytanie ${vm.currentQuestionNumber} / ${vm.totalQuestions}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          
          const SizedBox(height: 8),
          
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

  
  Widget _buildQuestionWidget(FinalTestViewModel vm) {
    final question = vm.currentQuestion;
    
    if (question == null) {
      return const Center(child: Text('Brak pytania'));
    }

    switch (question.questionType) {
      case 'closed':
        return QuizFirstTypeWidget(
          key: _firstTypeKey,
          question: question,
          onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
          onAnswerSelected: () => vm.onAnswerSelected(),
        );
      
      case 'yesno':
      case 'enter':
        return QuizSecondTypeWidget(
          key: _secondTypeKey,
          question: question,
          onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
          onAnswerSelected: () => vm.onAnswerSelected(),
        );
      
      case 'match':
        return QuizThirdTypeWidget(
          key: ValueKey(question.id),
          question: question,
          onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
        );
      
      default:
        return Center(child: Text('Nieznany typ: ${question.questionType}'));
    }
  }

  
  Widget _buildNextButton(FinalTestViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 12, 35, 35),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: (vm.canSubmitAnswer && !vm.isAnswerSubmitted) 
              ? () => _handleNextButton(vm)
              : (vm.isAnswerSubmitted ? () => vm.moveToNextQuestion() : null),
          style: ElevatedButton.styleFrom(
            backgroundColor: (vm.canSubmitAnswer || vm.isAnswerSubmitted)
                ? const Color.fromARGB(255, 6, 197, 70)
                : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            vm.isAnswerSubmitted ? "Następne pytanie" : "Sprawdź",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _handleNextButton(FinalTestViewModel vm) {
    final question = vm.currentQuestion;
    if (question == null) return;

    bool validated = false;
    
    if (question.questionType == 'closed') {
      validated = _firstTypeKey.currentState?.validateAndSubmit() ?? false;
    } else if (question.questionType == 'yesno' || question.questionType == 'enter') {
      validated = _secondTypeKey.currentState?.validateAndSubmit() ?? false;
    }
    
    if (validated) {
      
    }
  }
}