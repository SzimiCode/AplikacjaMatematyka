import 'package:aplikacjamatematyka/features/quiz/view/widgets/content_lesson_widget.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/lesson_content_page.dart';


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
      body: Column(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
               onPressed: () {
                widget.viewModel.onBackButtonPressed();
              },
            ),
            const ContentLessonWidget(
              number: 1,
              title: "Hsdad",
            ),
          ],
        ),
    );
  }
}

