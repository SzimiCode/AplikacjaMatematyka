import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/finish_quiz_page_viewmodel.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbars/appbar_lesson_widget.dart';

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
      backgroundColor: const Color.fromARGB(255, 165, 12, 192),

      appBar: AppbarLessonWidget(
        onBack: widget.viewModel.onBackButtonPressed,
      ),

      body: Column(
        children: [],

      ),
    );
  }
}
