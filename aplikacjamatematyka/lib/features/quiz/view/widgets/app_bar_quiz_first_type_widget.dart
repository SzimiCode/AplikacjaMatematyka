import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_first_type_page_viewmodel.dart';
import 'package:aplikacjamatematyka/features/quiz/data/questions.dart';


class AppBarQuizFirstTypeWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarQuizFirstTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // Tutaj można dodać okno potwierdzenia
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Consumer<QuizFirstTypePageViewModel>(
              builder: (context, vm, child) {
                final progress = (vm.currentQuestionIndex / questions.length).clamp(0.0, 1.0);
                final isFinished = vm.isQuizFinished;

                return Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 216, 168, 224),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: progress,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 120, 0, 160),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      isFinished ? 'assets/images/fire1.png' : 'assets/images/fire2.png',
                      height: 24,
                      width: 24,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
