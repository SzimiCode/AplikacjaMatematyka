import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/view/pages/test_test_page.dart';

class ChooseLessonPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
    void onTestButtonPressed(context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TestTestPage()),
    );
  }
}