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
      await _apiService.logout();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wylogowano pomyślnie'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
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

  Future<void> resetProgress(BuildContext context) async {
    try {
      final result = await _apiService.resetUserProgress();
      
      if (result['success']) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Postęp został zresetowany! Usunięto ${result['data']['deleted_courses']} kursów.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
          
          selectedPageNotifier.value = 0;
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błąd: ${result['error']}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd połączenia: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    notifyListeners();
  }
}