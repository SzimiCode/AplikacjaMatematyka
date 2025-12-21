import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/repository/course_repository.dart';

class ChooseLessonPageViewmodel {
  final CourseRepository _repository = CourseRepository();
  
  List<ClassModel> availableClasses = [];
  
  // inicjalizacja viewmodelu i załadowanie kategorii dla domyślnej klasy
  Future<void> initialize() async {
    availableClasses = await _repository.getClasses();
    
    if (availableClasses.isNotEmpty) {
      selectedClassNotifier.value = availableClasses.first;
      await loadCategories();
    }
  }
  
  // przelaczanie klas 1-4 i 5-8
  void toggleClass() {
    if (availableClasses.isEmpty) return;
    
    final currentIndex = availableClasses.indexOf(selectedClassNotifier.value!);
    final nextIndex = (currentIndex + 1) % availableClasses.length;
    
    selectedClassNotifier.value = availableClasses[nextIndex];
    
    selectedCategoryNotifier.value = null;
    coursesNotifier.value = [];
    
    loadCategories();
  }

  // ładowanie kategorii dla wybranej klasy
  Future<void> loadCategories() async {
    if (selectedClassNotifier.value == null) return;
    
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
      categoriesNotifier.value = [];
    }
  }

  // wybór kategorii
  Future<void> selectCategory(CategoryModel category) async {
    selectedCategoryNotifier.value = category;
    await loadCourses();
  }

  // załadowanie kursów dla wybranej kategorii
  Future<void> loadCourses() async {
    if (selectedCategoryNotifier.value == null) return;
    
    try {
      final courses = await _repository.getCourses(
        selectedCategoryNotifier.value!.id
      );
      
      coursesNotifier.value = courses;
    } catch (e) {
      coursesNotifier.value = [];
    }
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