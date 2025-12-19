import 'package:aplikacjamatematyka/features/quiz/view/widgets/contents/content_lesson_widget.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/lesson_content_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbars/appbar_lesson_widget.dart';

class LessonContentPage extends StatefulWidget {
  LessonContentPage({super.key});
  final LessonContentPageViewmodel viewModel = LessonContentPageViewmodel();

  @override
  State<LessonContentPage> createState() => _LessonContentPageState();
}

class _LessonContentPageState extends State<LessonContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 12, 192),

      appBar: AppbarLessonWidget(
        onBack: widget.viewModel.onBackButtonPressed,
      ),

      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: ContentLessonWidget(
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}