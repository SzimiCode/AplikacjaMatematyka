import 'package:aplikacjamatematyka/features/calculator/view/pages/calculator_page.dart';
import 'package:aplikacjamatematyka/features/chat/view/pages/chat_page.dart';
import 'package:aplikacjamatematyka/features/home/view/pages/home_page.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/choose_class_page.dart';
import 'package:aplikacjamatematyka/features/settings/view/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

List<Widget>pages = [
  HomePage(),
  ChooseClassPage(),
  ChatPage(),
  CalculatorPage(),
  SettingsPage(),
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