import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/lesson_card_widget.dart';
import 'dart:math';
import 'package:aplikacjamatematyka/features/quiz/model/tempLessons.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/choose_lesson_page_viewmodel.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class ChooseLessonPage extends StatefulWidget {
  ChooseLessonPage({super.key});
  final ChooseLessonPageViewmodel viewModel = ChooseLessonPageViewmodel();

  @override
  State<ChooseLessonPage> createState() => _ChooseLessonPageState();
}

class _ChooseLessonPageState extends State<ChooseLessonPage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tempLessonName,
      builder: (context, lessonName, child) {
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
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  return LessonCard(
                    number: index + 1,
                    title: lessons[index], 
                    color: _getColor(index),
                    flameCounter: Random().nextInt(5) + 1,
                    onTap: () => widget.viewModel.onLessonButtonPressed(index), 
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: const NavBarWidget(),
        );
      }
    );
  }
}

Color _getColor(int index) {
  const colors = [
    Colors.purple,
    Colors.purpleAccent,
  ];
  return colors[index % colors.length];
}
