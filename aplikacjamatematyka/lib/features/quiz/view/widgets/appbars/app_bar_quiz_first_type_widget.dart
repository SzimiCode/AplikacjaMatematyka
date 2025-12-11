import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/quiz_page_viewmodel.dart';
import 'package:aplikacjamatematyka/features/quiz/data/questions.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';


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
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Czy na pewno chcesz wyjść?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text("Zostaniesz przeniesiony do menu i utracisz postęp."),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Nie"),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); 
                            selectedPageNotifier.value = 0; 
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Tak"),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
},

                ),

              ],
            ),
            const SizedBox(height: 8),
            Consumer<QuizPageViewModel>(
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
