import 'package:aplikacjamatematyka/services/api_service.dart';
import 'package:aplikacjamatematyka/features/quiz/model/class_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/course_model.dart';
import 'package:aplikacjamatematyka/features/quiz/model/question_model.dart';

class CourseRepository {
  final ApiService _apiService;

  CourseRepository({ApiService? apiService}) 
      : _apiService = apiService ?? ApiService();

  // pobieranie klas szkolnych z bazy danych
  Future<List<ClassModel>> getClasses() async {
    try {
      final data = await _apiService.fetchClasses();
      if (data == null) return [];
      
      return data.map((json) => ClassModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // pobieranie kategorii z bazy danych
  Future<List<CategoryModel>> getCategories(int classId) async {
    try {
      final data = await _apiService.fetchCategories(classId: classId);
      if (data == null) return [];
      
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // pobieranie kursow z bazy danych
  Future<List<CourseModel>> getCourses(int categoryId) async {
    try {
      final data = await _apiService.fetchCourses(categoryId: categoryId);
      if (data == null) return [];
      
      return data.map((json) => CourseModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  // pobieranie szczegolow kursu
  Future<CourseModel?> getCourseDetail(int courseId) async {
    try {
      final data = await _apiService.fetchCourseDetail(courseId);
      if (data == null) return null;
      
      return CourseModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // pobieranie pytan z bazy danych
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
}