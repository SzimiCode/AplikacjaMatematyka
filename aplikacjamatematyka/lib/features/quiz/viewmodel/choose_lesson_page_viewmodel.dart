// lib/features/quiz/viewmodel/choose_lesson_page_viewmodel.dart
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';
import 'package:flutter/material.dart';

class ChooseLessonPageViewmodel {
  final CourseRepository _repository = CourseRepository();
  
  // Lista dostępnych klas (będzie pobrana z API przy inicjalizacji)
  List<ClassModel> availableClasses = [];

  // ========== INITIALIZATION ==========
  
  Future<void> initialize() async {
    print('🔥 INITIALIZE START');
    
    // Pobierz wszystkie klasy z API
    availableClasses = await _repository.getClasses();
    print('📚 Pobrano klas: ${availableClasses.length}');
    
    for (var c in availableClasses) {
      print('  - ${c.className} (ID: ${c.id})');
    }
    
    // Jeśli są klasy, ustaw pierwszą jako domyślną (np. "Klasy 1-4")
    if (availableClasses.isNotEmpty) {
      selectedClassNotifier.value = availableClasses.first;
      print('✅ Wybrano klasę: ${availableClasses.first.className}');
      await loadCategories();
    } else {
      print('❌ BRAK KLAS W BAZIE!');
    }
  }

  // ========== CLASS TOGGLE ==========
  
  void toggleClass() {
    if (availableClasses.isEmpty) return;
    
    // Przełącz między klasami (1-4 ⟷ 5-8)
    final currentIndex = availableClasses.indexOf(selectedClassNotifier.value!);
    final nextIndex = (currentIndex + 1) % availableClasses.length;
    
    selectedClassNotifier.value = availableClasses[nextIndex];
    
    // Reset kategorii i kursów
    selectedCategoryNotifier.value = null;
    coursesNotifier.value = [];
    
    // Załaduj kategorie dla nowej klasy
    loadCategories();
  }

  // ========== LOAD CATEGORIES ==========
  
  Future<void> loadCategories() async {
    if (selectedClassNotifier.value == null) return;
    
    print('🔥 LOAD CATEGORIES for class: ${selectedClassNotifier.value!.className}');
    
    isLoadingCategories.value = true;
    errorMessage.value = null;
    
    try {
      final categories = await _repository.getCategories(
        selectedClassNotifier.value!.id
      );
      
      print('📂 Pobrano kategorii: ${categories.length}');
      for (var cat in categories) {
        print('  - ${cat.categoryName} (ID: ${cat.id})');
      }
      
      categoriesNotifier.value = categories;
      
      // Jeśli są kategorie, ustaw pierwszą jako domyślną
      if (categories.isNotEmpty) {
        selectedCategoryNotifier.value = categories.first;
        print('✅ Wybrano kategorię: ${categories.first.categoryName}');
        await loadCourses();
      } else {
        print('❌ BRAK KATEGORII dla tej klasy!');
      }
    } catch (e) {
      print('❌ BŁĄD loadCategories: $e');
      errorMessage.value = 'Błąd ładowania kategorii: $e';
      categoriesNotifier.value = [];
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // ========== SELECT CATEGORY ==========
  
  Future<void> selectCategory(CategoryModel category) async {
    selectedCategoryNotifier.value = category;
    await loadCourses();
  }

  // ========== LOAD COURSES ==========
  
  Future<void> loadCourses() async {
    if (selectedCategoryNotifier.value == null) return;
    
    print('🔥 LOAD COURSES for category: ${selectedCategoryNotifier.value!.categoryName}');
    
    isLoadingCourses.value = true;
    errorMessage.value = null;
    
    try {
      final courses = await _repository.getCourses(
        selectedCategoryNotifier.value!.id
      );
      
      print('📚 Pobrano kursów: ${courses.length}');
      for (var course in courses) {
        print('  - ${course.courseName} (ID: ${course.id})');
      }
      
      coursesNotifier.value = courses;
    } catch (e) {
      print('❌ BŁĄD loadCourses: $e');
      errorMessage.value = 'Błąd ładowania kursów: $e';
      coursesNotifier.value = [];
    } finally {
      isLoadingCourses.value = false;
    }
  }

  // ========== LESSON BUTTON PRESSED ==========
  
  void onLessonButtonPressed(int index) {
    if (index >= 0 && index < coursesNotifier.value.length) {
      final selectedCourse = coursesNotifier.value[index];
      
      // Zapisz wybrany kurs
      selectedCourseNotifier.value = selectedCourse;
      
      // Zapisz nazwę kursu (dla kompatybilności z istniejącym kodem)
      tempLessonName.value = selectedCourse.courseName;
      
      print('🎯 Selected course: ${selectedCourse.courseName}');
      print('🎯 Course ID: ${selectedCourse.id}');
      

      selectedPageNotifier.value = 6;
    }
  }
}