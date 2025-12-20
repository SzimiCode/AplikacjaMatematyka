import 'answer_option_model.dart';
import 'match_option_model.dart';

class QuestionModel {
  final int id;
  final int courseId;
  final int? difficultyLevelId;
  final String difficultyLevelName;
  final String questionType; // 'closed', 'enter', 'yesno', 'match'
  final String questionText;
  final String correctAnswer;
  final int points;
  final String explanation;
  final List<AnswerOptionModel> options;
  final List<MatchOptionModel> matchOptions;

  QuestionModel({
    required this.id,
    required this.courseId,
    this.difficultyLevelId,
    required this.difficultyLevelName,
    required this.questionType,
    required this.questionText,
    required this.correctAnswer,
    required this.points,
    required this.explanation,
    required this.options,
    required this.matchOptions,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      courseId: json['course'] ?? 0,
      difficultyLevelId: json['difficulty_level'],
      difficultyLevelName: json['difficulty_level_name'] ?? '',
      questionType: json['question_type'] ?? '',
      questionText: json['question_text'] ?? '',
      correctAnswer: json['correct_answer'] ?? '',
      points: json['points'] ?? 1,
      explanation: json['explanation'] ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => AnswerOptionModel.fromJson(e))
              .toList() ??
          [],
      matchOptions: (json['match_options'] as List<dynamic>?)
              ?.map((e) => MatchOptionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}