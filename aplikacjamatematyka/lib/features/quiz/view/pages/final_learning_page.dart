import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/final_learning_viewmodel.dart';
import '../widgets/appbars/appbar_quiz_widget.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_first_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_second_type_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/quiz_types/quiz_third_type_widget.dart';

class FinalLearningPage extends StatefulWidget {
  const FinalLearningPage({super.key});

  @override
  State<FinalLearningPage> createState() => _FinalLearningPageState();
}

class _FinalLearningPageState extends State<FinalLearningPage> {

  final GlobalKey<QuizFirstTypeWidgetState> _firstTypeKey = GlobalKey();
  final GlobalKey<QuizSecondTypeWidgetState> _secondTypeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalLearningViewModel(),
      child: Consumer<FinalLearningViewModel>(
        builder: (context, vm, child) {
    
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

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: QuizAppBar(
              progress: vm.progress,
              isFinished: vm.isLearningFinished,
            ),
            body: Column(
              children: [
                _buildDifficultyHeader(vm),
                
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

  
  Widget _buildQuestionWidget(FinalLearningViewModel vm) {
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

  
  Widget _buildNextButton(FinalLearningViewModel vm) {
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

  void _handleNextButton(FinalLearningViewModel vm) {
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