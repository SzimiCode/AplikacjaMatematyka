import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class SettingsViewModel extends ChangeNotifier {

  bool _isNotificationsEnabled = true;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  void toggleDarkMode() {
    isDarkModifier.value = !isDarkModifier.value;
    notifyListeners();  
  }


  void toggleNotifications(bool value) {
    _isNotificationsEnabled = value;
    notifyListeners();
  }

  void logout() {
 
  }
}
