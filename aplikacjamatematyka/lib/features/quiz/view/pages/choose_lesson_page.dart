import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbars/appbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/contents/lesson_card_widget.dart';
import 'dart:math';
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
  void initState() {
    super.initState();
    widget.viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: tempLessonName,
      builder: (context, lessonName, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 165, 12, 192),
          appBar: AppbarWidget(
            onClassToggle: () {
              widget.viewModel.toggleClass();
            },
            onCategorySelected: (category) {
              widget.viewModel.selectCategory(category);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: ValueListenableBuilder(
                valueListenable: coursesNotifier,
                builder: (context, courses, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      
                      return LessonCard(
                        number: index + 1,
                        title: course.courseName,
                        color: _getColor(index),
                        flameCounter: Random().nextInt(5) + 1,
                        onTap: () => widget.viewModel.onLessonButtonPressed(index),
                      );
                    },
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
    Colors.purpleAccent,
  ];
  return colors[index % colors.length];
}