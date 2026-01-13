import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/services/api_service.dart';

class HomePageViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  String userName = 'Ładowanie...';
  String dragonName = 'Smok Mat';
  int totalPoints = 0;
  int userLevel = 1;
  int pointsInCurrentLevel = 0;  
  int pointsToNextLevel = 5;     
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
        dragonName = 'Smok Mat';
        totalPoints = userData['total_points'] ?? 0;
        
        
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
  
  void _calculateLevel() {
    if (totalPoints == 0) {
      userLevel = 1;
      pointsInCurrentLevel = 0;
      pointsToNextLevel = POINTS_PER_LEVEL;
    } else {
      userLevel = (totalPoints ~/ POINTS_PER_LEVEL) + 1;
      
      pointsInCurrentLevel = totalPoints % POINTS_PER_LEVEL;
      
      pointsToNextLevel = POINTS_PER_LEVEL;
    }
  }
  
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