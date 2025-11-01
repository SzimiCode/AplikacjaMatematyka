import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class CalculatorPageViewmodel {
  void onButtonPressed() {
    debugPrint('Calculate strona!');
  }
   void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
}