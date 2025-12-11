import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/tempLessons.dart';

class ChooseLessonPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }

   void onLessonButtonPressed(index){
    tempLessonName.value = lessons[index];
    selectedPageNotifier.value = 6;
  }
}