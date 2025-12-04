import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/services/api_service.dart';

class HomePageViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  String userName = 'Ładowanie...';
  String dragonName = 'Smoczek';
  int totalPoints = 0;
  int userLevel = 1;
  int pointsInCurrentLevel = 0;  // Ile punktów w obecnym poziomie
  int pointsToNextLevel = 5;     // Ile trzeba do następnego poziomu
  bool isLoading = true;
  
  // STAŁA - ile punktów na 1 poziom
  static const int POINTS_PER_LEVEL = 5;
  
  // Pobierz dane użytkownika
  Future<void> fetchUserData() async {
    isLoading = true;
    notifyListeners();
    
    try {
      final result = await _apiService.getUserProfile();
      
      if (result['success']) {
        final userData = result['data'];
        userName = userData['nick'] ?? 'User';
        dragonName = userData['dragon_name'] ?? 'Smoczek';
        totalPoints = userData['total_points'] ?? 0;
        
        // OBLICZ POZIOM I POSTĘP
        _calculateLevel();
      } else {
        userName = 'Błąd';
      }
    } catch (e) {
      userName = 'Błąd';
      debugPrint('Błąd pobierania danych: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  // Oblicz poziom na podstawie total_points
  void _calculateLevel() {
    if (totalPoints == 0) {
      userLevel = 1;
      pointsInCurrentLevel = 0;
      pointsToNextLevel = POINTS_PER_LEVEL;
    } else {
      // Poziom = (total_points ÷ 5) + 1
      userLevel = (totalPoints ~/ POINTS_PER_LEVEL) + 1;
      
      // Punkty w obecnym poziomie = total_points % 5
      pointsInCurrentLevel = totalPoints % POINTS_PER_LEVEL;
      
      // Zawsze 5 punktów do następnego poziomu
      pointsToNextLevel = POINTS_PER_LEVEL;
    }
  }
  
  // Progress (0.0 - 1.0) dla progress bara
  double get levelProgress {
    return pointsInCurrentLevel / pointsToNextLevel;
  }
  
  void onButtonPressed() {
    debugPrint('Przycisk kliknięty!');
  }
  
  void onBackButtonPressed() {
    selectedPageNotifier.value = 0;
  }
  
  void goToSettingsButtonPressed() {
    selectedPageNotifier.value = 4;
  }
}