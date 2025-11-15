import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/lesson_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/choose_lesson_page_viewmodel.dart';

class ChooseLessonPage extends StatefulWidget {
  ChooseLessonPage({super.key});
  final ChooseLessonPageViewmodel viewModel = ChooseLessonPageViewmodel();

  @override
  State<ChooseLessonPage> createState() => _ChooseLessonPageState();
}

class _ChooseLessonPageState extends State<ChooseLessonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(),
      body: Center(
        child: ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            return LessonCard(
              number: index + 1,
              //title: lessons[index].title
              title: "Lekcja ${index + 1}",
              time: "${20 + index * 5} min",
              //time: lessons[index].time
              color: _getColor(index),
            );
          },
        ),
      ), 
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}

Color _getColor(int index) {
  const colors = [
    Colors.lightBlue,
    Colors.orange,
    Colors.purple,
    Colors.deepOrange,
    Colors.blue,
    Colors.purpleAccent,
  ];
  return colors[index % colors.length];
}
