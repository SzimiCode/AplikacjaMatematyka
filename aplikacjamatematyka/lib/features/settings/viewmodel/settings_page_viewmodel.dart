import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class SettingsViewModel extends ChangeNotifier {

  void toggleDarkMode() {
    isDarkModifier.value = !isDarkModifier.value;
    notifyListeners();  
  }

  void logout() {

  }
}
