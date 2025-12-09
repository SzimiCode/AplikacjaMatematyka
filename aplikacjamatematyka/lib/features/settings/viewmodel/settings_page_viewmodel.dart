import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/services/api_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  void toggleDarkMode() {
    isDarkModifier.value = !isDarkModifier.value;
    notifyListeners();  
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Usuń token z pamięci
      await _apiService.logout();
      
      // Pokaż wiadomość
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wylogowano pomyślnie'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        // Przekieruj do strony logowania (index 7)
        selectedPageNotifier.value = 7;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Błąd podczas wylogowania'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    notifyListeners();
  }

  void onBackButtonPressed() {
    selectedPageNotifier.value = 0;
  }
}