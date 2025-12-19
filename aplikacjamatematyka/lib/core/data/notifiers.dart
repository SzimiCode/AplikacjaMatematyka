import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';

// ========== EXISTING NOTIFIERS ==========
ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModifier = ValueNotifier(false);
ValueNotifier<String> tempLessonName = ValueNotifier("");

// ========== NEW NOTIFIERS FOR COURSE SELECTION ==========

// Wybrana klasa (1-4 lub 5-8)
ValueNotifier<ClassModel?> selectedClassNotifier = ValueNotifier(null);

// Wybrana kategoria
ValueNotifier<CategoryModel?> selectedCategoryNotifier = ValueNotifier(null);

// Wybrany kurs (dla quizu)
ValueNotifier<CourseModel?> selectedCourseNotifier = ValueNotifier(null);

// Lista kategorii dla wybranej klasy
ValueNotifier<List<CategoryModel>> categoriesNotifier = ValueNotifier([]);

// Lista kursów dla wybranej kategorii
ValueNotifier<List<CourseModel>> coursesNotifier = ValueNotifier([]);

// Loading states
ValueNotifier<bool> isLoadingCategories = ValueNotifier(false);
ValueNotifier<bool> isLoadingCourses = ValueNotifier(false);

// Error messages
ValueNotifier<String?> errorMessage = ValueNotifier(null);