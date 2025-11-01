import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class ChatPageViewmodel {
  void onButtonPressed() {
    debugPrint('Przycisk w ChatPage kliknięty!');
  }
  void onBackButtonPressed(){
    selectedPageNotifier.value = 0;
  }
}