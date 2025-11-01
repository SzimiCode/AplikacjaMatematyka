import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class TestTestPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
    void onAnswerPressed(String answer) {

    }

}