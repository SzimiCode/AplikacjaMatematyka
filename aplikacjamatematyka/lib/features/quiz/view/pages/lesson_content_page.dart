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
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 165, 12, 192),
        title:
        IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
               onPressed: () {
                widget.viewModel.onBackButtonPressed();
              },
            ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
         child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: ContentLessonWidget(
            number: 1,
            title: "Hsdad",
          ),
        ),
      ),
    );
  }
}

