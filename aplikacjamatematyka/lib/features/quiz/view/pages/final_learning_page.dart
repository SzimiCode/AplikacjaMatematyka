import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/final_learning_viewmodel.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_first_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_second_type_widget.dart';

import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_third_type_widget.dart';


class FinalLearningPage extends StatelessWidget {
  const FinalLearningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalLearningViewModel(),
      child: Consumer<FinalLearningViewModel>(
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

          // Stan ukończenia
          if (vm.isLearningFinished) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.goToFinishPage();
            });
            
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Stan normalny - nauka w trakcie
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.progress,
              isFinished: vm.isLearningFinished,
            ),
            body: Column(
              children: [
                // Etykieta poziomu trudności + kropki
                _buildDifficultyHeader(vm),
                
                // Główna treść - dynamiczny widget pytania
                Expanded(
                  child: _buildQuestionWidget(context, vm),
                ),
                
                // Przycisk "Dalej"
                _buildNextButton(vm),
              ],
            ),
          );
        },
      ),
    );
  }

  // ========== HEADER Z POZIOMEM I KROPKAMI ==========
  
  Widget _buildDifficultyHeader(FinalLearningViewModel vm) {
    String difficultyText;
    Color difficultyColor;
    
    switch (vm.currentDifficulty) {
      case DifficultyLevel.easy:
        difficultyText = 'Łatwy';
        difficultyColor = const Color.fromARGB(255, 6, 197, 70);
        break;
      case DifficultyLevel.medium:
        difficultyText = 'Średni';
        difficultyColor = Colors.orange;
        break;
      case DifficultyLevel.hard:
        difficultyText = 'Trudny';
        difficultyColor = Colors.red;
        break;
    }
    
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
          // Etykieta poziomu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: difficultyColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              difficultyText.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 3 kropki progresji
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isActive = index < vm.streakCount;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? difficultyColor : Colors.grey.shade300,
                ),
              );
            }),
          ),
          
          const SizedBox(height: 8),
          
          // Numer pytania
          Text(
            'Pytanie ${vm.questionNumber}${vm.needsBonusQuestion ? " (BONUS)" : ""} / ${vm.maxQuestions}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ========== DYNAMICZNY WIDGET PYTANIA ==========
  
  Widget _buildQuestionWidget(BuildContext context, FinalLearningViewModel vm) {
  final question = vm.currentQuestion;
  
  if (question == null) {
    return const Center(child: Text('Brak pytania'));
  }

  switch (question.questionType) {
    case 'closed':
      return QuizFirstTypeWidget(
        question: question,
        onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
      );
    
    case 'yesno':
    case 'enter':
      return QuizSecondTypeWidget(
        question: question,
        onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
      );
    
    case 'match':
      return QuizThirdTypeWidget(
        question: question,
        onAnswerSubmitted: (isCorrect) => vm.onAnswerSubmitted(isCorrect),
      );
    
    default:
      return Center(child: Text('Nieznany typ: ${question.questionType}'));
  }
}

  // ========== PLACEHOLDERY (ZAMIENIMY NA PRAWDZIWE WIDGETY) ==========
  
  Widget _buildClosedQuestionPlaceholder(dynamic question) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(35),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.quiz, size: 48, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'PYTANIE ZAMKNIĘTE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '🔨 Tu będzie QuizFirstTypeWidget',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpenQuestionPlaceholder(dynamic question) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(35),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              question.questionType == 'yesno' ? 'TAK/NIE' : 'WPISZ ODPOWIEDŹ',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '🔨 Tu będzie QuizSecondTypeWidget',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchQuestionPlaceholder(dynamic question) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(35),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.purple.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.swap_horiz, size: 48, color: Colors.purple),
            const SizedBox(height: 16),
            const Text(
              'DOPASUJ PARY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.questionText.isNotEmpty 
                  ? question.questionText 
                  : 'Dopasuj poniższe elementy',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '🔨 Tu będzie QuizThirdTypeWidget',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ========== PRZYCISK DALEJ ==========
  
  Widget _buildNextButton(FinalLearningViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 12, 35, 35),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: vm.isAnswerSubmitted ? () => vm.moveToNextQuestion() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: vm.isAnswerSubmitted
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