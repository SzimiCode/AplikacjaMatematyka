import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbar_widget.dart';
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
    appBar: AppbarWidget(),
      body: Center(
        child: ListView.builder(
          //Tutaj do zmiany, żeby brało z bazy danych
          itemCount: 7, 
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                
              },
              child: Text("Lekcja ${index + 1}"),
            );
          },
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}
