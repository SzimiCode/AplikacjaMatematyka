import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class ChooseClassPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    if (selectedPageNotifier.value > 0) {
    selectedPageNotifier.value -= 1;
  }
  }
}