class AnswerOptionModel {
  final int id;
  final String optionText;
  final bool isCorrect;
  final int displayOrder;

  AnswerOptionModel({
    required this.id,
    required this.optionText,
    required this.isCorrect,
    required this.displayOrder,
  });

  factory AnswerOptionModel.fromJson(Map<String, dynamic> json) {
    return AnswerOptionModel(
      id: json['id'] ?? 0,
      optionText: json['option_text'] ?? '',
      isCorrect: json['is_correct'] ?? false,
      displayOrder: json['display_order'] ?? 0,
    );
  }
}