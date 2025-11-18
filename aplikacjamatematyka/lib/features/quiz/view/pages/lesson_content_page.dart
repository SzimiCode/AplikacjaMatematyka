import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbar_widget.dart';
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
      appBar: const AppbarWidget(),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40), 
            ),
          ),
          child: const ContentLessonWidget(
            number: 1,
            title: "Hsdad",
          ),
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}

