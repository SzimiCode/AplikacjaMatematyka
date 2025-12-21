import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModifier = ValueNotifier(false);
ValueNotifier<String> tempLessonName = ValueNotifier("");

// notifiery do modeli bazy danych
// wybrana klasa szkolna
ValueNotifier<ClassModel?> selectedClassNotifier = ValueNotifier(null);
// wybrana kategoria
ValueNotifier<CategoryModel?> selectedCategoryNotifier = ValueNotifier(null);
// wybrany kurs
ValueNotifier<CourseModel?> selectedCourseNotifier = ValueNotifier(null);
// list kategorii
ValueNotifier<List<CategoryModel>> categoriesNotifier = ValueNotifier([]);
// lista kursow dla wybranej kategorii
ValueNotifier<List<CourseModel>> coursesNotifier = ValueNotifier([]);

// stan ladowania danych
ValueNotifier<bool> isLoadingCategories = ValueNotifier(false);
ValueNotifier<bool> isLoadingCourses = ValueNotifier(false);

// error
ValueNotifier<String?> errorMessage = ValueNotifier(null);