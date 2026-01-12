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
  
  Map<int, CourseProgressModel> courseProgress = {};

  Future<void> initialize() async {
    availableClasses = await _repository.getClasses();
    
    if (availableClasses.isNotEmpty) {
      selectedClassNotifier.value = availableClasses.first;
      await loadCategories();
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
        
    isLoadingCategories.value = true;
    errorMessage.value = null;
    
    try {
      final categories = await _repository.getCategories(
        selectedClassNotifier.value!.id
      );
      
      categoriesNotifier.value = categories;
      
      if (categories.isNotEmpty) {
        selectedCategoryNotifier.value = categories.first;
        await loadCourses();
      }
    } catch (e) {
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
    
    isLoadingCourses.value = true;
    errorMessage.value = null;
    
    try {
      final courses = await _repository.getCourses(
        selectedCategoryNotifier.value!.id
      );
      
      coursesNotifier.value = courses;
      
      await _loadCourseProgress();
    } catch (e) {
      errorMessage.value = 'Błąd ładowania kursów: $e';
      coursesNotifier.value = [];
    } finally {
      isLoadingCourses.value = false;
    }
  }

  Future<void> _loadCourseProgress() async {
    for (final course in coursesNotifier.value) {
      try {
        final progress = await _repository.getCourseProgress(course.id);
        if (progress != null) {
          courseProgress[course.id] = progress;
        } else {
          courseProgress[course.id] = CourseProgressModel.empty();
        }
      } catch (e) {
        courseProgress[course.id] = CourseProgressModel.empty();
      }
    }
  }

  int getFiresForCourse(int courseId) {
    return courseProgress[courseId]?.firesEarned ?? 0;
  }

  void onLessonButtonPressed(int index) {
    if (index >= 0 && index < coursesNotifier.value.length) {
      final selectedCourse = coursesNotifier.value[index];
      
      selectedCourseNotifier.value = selectedCourse;
      tempLessonName.value = selectedCourse.courseName;
      
      selectedPageNotifier.value = 6;
    }
  }
}