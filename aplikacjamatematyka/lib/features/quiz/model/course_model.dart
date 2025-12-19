class CourseModel {
  final int id;
  final int categoryId;
  final String categoryName;
  final String courseName;
  final String description;
  final String videoUrl;
  final int videoDuration;
  final int pointsPerQuestion;
  final int requiredCorrectAnswers;
  final int displayOrder;
  final String createdAt;

  CourseModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.courseName,
    required this.description,
    required this.videoUrl,
    required this.videoDuration,
    required this.pointsPerQuestion,
    required this.requiredCorrectAnswers,
    required this.displayOrder,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      categoryId: json['category'] ?? 0,
      categoryName: json['category_name'] ?? '',
      courseName: json['course_name'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['video_url'] ?? '',
      videoDuration: json['video_duration'] ?? 0,
      pointsPerQuestion: json['points_per_question'] ?? 1,
      requiredCorrectAnswers: json['required_correct_answers'] ?? 5,
      displayOrder: json['display_order'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': categoryId,
      'category_name': categoryName,
      'course_name': courseName,
      'description': description,
      'video_url': videoUrl,
      'video_duration': videoDuration,
      'points_per_question': pointsPerQuestion,
      'required_correct_answers': requiredCorrectAnswers,
      'display_order': displayOrder,
      'created_at': createdAt,
    };
  }
}