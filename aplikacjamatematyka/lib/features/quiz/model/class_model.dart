class ClassModel {
  final int id;
  final String className;
  final String description;
  final int displayOrder;

  ClassModel({
    required this.id,
    required this.className,
    required this.description,
    required this.displayOrder,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      className: json['class_name'] ?? '',
      description: json['description'] ?? '',
      displayOrder: json['display_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
      'description': description,
      'display_order': displayOrder,
    };
  }
}