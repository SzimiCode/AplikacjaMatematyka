import 'package:aplikacjamatematyka/features/home/view/widgets/navbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/appbars/appbar_widget.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/contents/lesson_card_widget.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/viewmodel/choose_lesson_page_viewmodel.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/services/api_service.dart';

class ChooseLessonPage extends StatefulWidget {
  ChooseLessonPage({super.key});
  final ChooseLessonPageViewmodel viewModel = ChooseLessonPageViewmodel();

  @override
  State<ChooseLessonPage> createState() => _ChooseLessonPageState();
}

class _ChooseLessonPageState extends State<ChooseLessonPage> {
  int totalPoints = 0;

  @override
  void initState() {
    super.initState();
    // Inicjalizacja - pobierz klasy i kategorie
    widget.viewModel.initialize();

    _loadUserPoints();
  }

  Future<void> _loadUserPoints() async {
    final apiService = ApiService();
    final result = await apiService.getUserProfile();
    if (result['success']) {
      setState(() {
        totalPoints = result['data']['total_points'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 12, 192),
      appBar: AppbarWidget(
        onClassToggle: () {
          widget.viewModel.toggleClass();
        },
        onCategorySelected: (category) {
          widget.viewModel.selectCategory(category);
        },
        totalPoints: totalPoints,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable: isLoadingCourses,
            builder: (context, isLoading, child) {
              // LOADING STATE
              if (isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color.fromARGB(255, 165, 12, 192),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Ładowanie kursów...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // ERROR STATE
              return ValueListenableBuilder(
                valueListenable: errorMessage,
                builder: (context, error, child) {
                  if (error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text(
                            error,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              widget.viewModel.loadCourses();
                            },
                            child: Text('Spróbuj ponownie'),
                          ),
                        ],
                      ),
                    );
                  }

                  // COURSES LIST
                  return ValueListenableBuilder(
                    valueListenable: coursesNotifier,
                    builder: (context, courses, child) {
                      // EMPTY STATE
                      if (courses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Brak kursów w tej kategorii',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              ValueListenableBuilder(
                                valueListenable: selectedCategoryNotifier,
                                builder: (context, category, child) {
                                  return Text(
                                    category != null
                                        ? 'Kategoria: ${category.categoryName}'
                                        : 'Wybierz kategorię powyżej',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }

                      // COURSES LIST
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          final fireCount = widget.viewModel.getFiresForCourse(course.id);

                          return LessonCard(
                            number: index + 1,
                            title: course.courseName,
                            color: _getColor(index),
                            flameCounter: fireCount,
                            onTap: () => widget.viewModel.onLessonButtonPressed(index),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const NavBarWidget(),
    );
  }
}

Color _getColor(int index) {
  const colors = [
    Colors.purpleAccent,
  ];
  return colors[index % colors.length];
}