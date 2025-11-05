import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {

  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;

  bool get isDarkMode => _isDarkMode;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();  
  }


  void toggleNotifications(bool value) {
    _isNotificationsEnabled = value;
    notifyListeners();
  }

  void logout() {
 
  }
}
