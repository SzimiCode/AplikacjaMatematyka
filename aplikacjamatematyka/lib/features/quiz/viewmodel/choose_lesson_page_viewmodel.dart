import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_progress_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';
import 'package:flutter/material.dart';

class ChooseLessonPageViewmodel {
  final CourseRepository _repository = CourseRepository();
  
  List<ClassModel> availableClasses = [];
  
  // 🔥 Mapa ogni dla kursów
  Map<int, CourseProgressModel> courseProgress = {};

  Future<void> initialize() async {
    print('🔥 INITIALIZE START');
    
    availableClasses = await _repository.getClasses();
    print('📚 Pobrano klas: ${availableClasses.length}');
    
    for (var c in availableClasses) {
      print('  - ${c.className} (ID: ${c.id})');
    }
    
    if (availableClasses.isNotEmpty) {
      selectedClassNotifier.value = availableClasses.first;
      print('✅ Wybrano klasę: ${availableClasses.first.className}');
      await loadCategories();
    } else {
      print('❌ BRAK KLAS W BAZIE!');
    }
  }

  void toggleClass() {
    if (availableClasses.isEmpty) return;
    
    final currentIndex = availableClasses.indexOf(selectedClassNotifier.value!);
    final nextIndex = (currentIndex + 1) % availableClasses.length;
    
    selectedClassNotifier.value = availableClasses[nextIndex];
    selectedCategoryNotifier.value = null;
    coursesNotifier.value = [];
    
    loadCategories();
  }

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

  Future<void> selectCategory(CategoryModel category) async {
    selectedCategoryNotifier.value = category;
    await loadCourses();
  }

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
      
      // 🔥 Pobierz ognie dla każdego kursu
      await _loadCourseProgress();
    } catch (e) {
      print('❌ BŁĄD loadCourses: $e');
      errorMessage.value = 'Błąd ładowania kursów: $e';
      coursesNotifier.value = [];
    } finally {
      isLoadingCourses.value = false;
    }
  }

  // 🔥 Pobierz postęp (ognie) dla wszystkich kursów
  Future<void> _loadCourseProgress() async {
    for (final course in coursesNotifier.value) {
      try {
        final progress = await _repository.getCourseProgress(course.id);
        if (progress != null) {
          courseProgress[course.id] = progress;
          print('🔥 Course ${course.id}: ${progress.firesEarned} fires');
        } else {
          courseProgress[course.id] = CourseProgressModel.empty();
        }
      } catch (e) {
        print('❌ Error loading progress for course ${course.id}: $e');
        courseProgress[course.id] = CourseProgressModel.empty();
      }
    }
  }

  // 🔥 Pobierz liczbę ogni dla kursu
  int getFiresForCourse(int courseId) {
    return courseProgress[courseId]?.firesEarned ?? 0;
  }

  void onLessonButtonPressed(int index) {
    if (index >= 0 && index < coursesNotifier.value.length) {
      final selectedCourse = coursesNotifier.value[index];
      
      selectedCourseNotifier.value = selectedCourse;
      tempLessonName.value = selectedCourse.courseName;
      
      print('🎯 Selected course: ${selectedCourse.courseName}');
      print('🎯 Course ID: ${selectedCourse.id}');
      
      selectedPageNotifier.value = 6;
    }
  }
}