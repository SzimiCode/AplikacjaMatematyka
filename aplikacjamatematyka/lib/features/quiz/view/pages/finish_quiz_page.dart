import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/finish_quiz_page_viewmodel.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';

class FinishQuizPage extends StatefulWidget {
  FinishQuizPage({super.key});
  final FinishQuizPageViewmodel viewModel = FinishQuizPageViewmodel();

  @override
  State<FinishQuizPage> createState() => _FinishQuizPageState();
}

class _FinishQuizPageState extends State<FinishQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
              Pallete.purpleColor,
              Pallete.purplemidColor,
              Pallete.whiteColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 520,
                    maxHeight: 720,
                    minWidth: 300,
                    minHeight: 400,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Pallete.blackColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text("Gratulacje Quizu"),
                    ),
                  ),
                ),
                
              ),
              SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(200, 58),
                            backgroundColor: Pallete.purpleColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "ODBIERZ     🔥",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
