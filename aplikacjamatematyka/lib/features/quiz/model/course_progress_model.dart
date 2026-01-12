class CourseProgressModel {
  final int firesEarned;
  final bool fireEasy;
  final bool fireMedium;
  final bool fireHard;
  final bool fireQuiz;

  CourseProgressModel({
    required this.firesEarned,
    required this.fireEasy,
    required this.fireMedium,
    required this.fireHard,
    required this.fireQuiz,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    return CourseProgressModel(
      firesEarned: json['fires_earned'] ?? 0,
      fireEasy: json['fire_easy'] ?? false,
      fireMedium: json['fire_medium'] ?? false,
      fireHard: json['fire_hard'] ?? false,
      fireQuiz: json['fire_quiz'] ?? false,
    );
  }

  factory CourseProgressModel.empty() {
    return CourseProgressModel(
      firesEarned: 0,
      fireEasy: false,
      fireMedium: false,
      fireHard: false,
      fireQuiz: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fires_earned': firesEarned,
      'fire_easy': fireEasy,
      'fire_medium': fireMedium,
      'fire_hard': fireHard,
      'fire_quiz': fireQuiz,
    };
  }
}