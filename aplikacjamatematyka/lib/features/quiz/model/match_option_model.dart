class MatchOptionModel {
  final int id;
  final int questionId;
  final String leftText;
  final String rightText;
  final int displayOrder;

  MatchOptionModel({
    required this.id,
    required this.questionId,
    required this.leftText,
    required this.rightText,
    required this.displayOrder,
  });

  factory MatchOptionModel.fromJson(Map<String, dynamic> json) {
    return MatchOptionModel(
      id: json['id'] ?? 0,
      questionId: json['question'] ?? 0,
      leftText: json['left_text'] ?? '',
      rightText: json['right_text'] ?? '',
      displayOrder: json['display_order'] ?? 0,
    );
  }
}