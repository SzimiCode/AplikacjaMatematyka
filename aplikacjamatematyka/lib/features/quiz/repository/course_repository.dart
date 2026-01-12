import 'package:aplikacjamatematyka/services/api_service.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_progress_model.dart';

class CourseRepository {
  final ApiService _apiService;

  CourseRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  // Pobierz wszystkie klasy
  Future<List<ClassModel>> getClasses() async {
    try {
      final data = await _apiService.fetchClasses();
      if (data == null) return [];
      
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Pobierz kategorie dla klasy
  Future<List<CategoryModel>> getCategories(int classId) async {
    try {
      final data = await _apiService.fetchCategories(classId: classId);
      if (data == null) return [];
      
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Pobierz kursy dla kategorii
  Future<List<CourseModel>> getCourses(int categoryId) async {
    try {
      final data = await _apiService.fetchCourses(categoryId: categoryId);
      if (data == null) return [];
      
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // Pobierz szczegóły kursu
  Future<CourseModel?> getCourseDetail(int courseId) async {
    try {
      final data = await _apiService.fetchCourseDetail(courseId);
      if (data == null) return null;
      
      return CourseModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // Pobierz pytania dla kursu
  Future<List<QuestionModel>> getQuestions({
    required int courseId,
    String? questionType,
    int? difficultyId,
  }) async {
    try {
      final data = await _apiService.fetchQuestions(
        courseId: courseId,
        questionType: questionType,
        difficultyId: difficultyId,
      );
      if (data == null) return [];
      
      return data.map((json) => QuestionModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> saveLearningProgress({
  required int courseId,
  bool fireEasy = false,
  bool fireMedium = false,
  bool fireHard = false,
  }) async {
    try {
      final result = await _apiService.saveLearningProgress(
        courseId: courseId,
        fireEasy: fireEasy,
        fireMedium: fireMedium,
        fireHard: fireHard,
      );
      return result;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> saveQuizProgress({
    required int courseId,
    required bool passed,
  }) async {
    try {
      final result = await _apiService.saveQuizProgress(
        courseId: courseId,
        passed: passed,
      );
      return result;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<CourseProgressModel?> getCourseProgress(int courseId) async {
    try {
      final result = await _apiService.getCourseProgress(courseId);
      if (result['success']) {
        return CourseProgressModel.fromJson(result['data']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}