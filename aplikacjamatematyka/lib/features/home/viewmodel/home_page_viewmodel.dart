import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class HomePageViewModel {
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
   void goToSettingsButtonPressed(){
    selectedPageNotifier.value = 4;
  }
}