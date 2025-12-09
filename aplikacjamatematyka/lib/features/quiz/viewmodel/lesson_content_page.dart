import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class LessonContentPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
   void onLessonButtonPressed(){
    selectedPageNotifier.value = 5;
  }
}