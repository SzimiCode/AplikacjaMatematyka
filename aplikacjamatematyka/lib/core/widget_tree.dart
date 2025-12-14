import 'package:aplikacjamatematyka/features/auth/view/pages/sign_in_page.dart';
import 'package:aplikacjamatematyka/features/auth/view/pages/sign_up_page.dart';
import 'package:aplikacjamatematyka/features/calculator/view/pages/calculator_page.dart';
import 'package:aplikacjamatematyka/features/chat/view/pages/chat_page.dart';
import 'package:aplikacjamatematyka/features/home/view/pages/home_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/choose_lesson_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/finish_quiz_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/quiz_first_type_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/lesson_content_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/quiz_second_type_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/quiz_third_type_page.dart';
import 'package:aplikacjamatematyka/features/settings/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

List<Widget>pages = [
  HomePage(),
  ChooseLessonPage(),
  ChatPage(),
  CalculatorPage(),
  SettingsPage(),
  QuizFirstTypePage(),
  LessonContentPage(),
  SignInPage(),
  QuizFirstTypePage(),
  QuizSecondTypePage(),
  QuizThirdTypePage(),
  SignUpPage(),
  FinishQuizPage(),
];


class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, value, child) {
              return pages.elementAt(value);
      },),
    );
  }
}