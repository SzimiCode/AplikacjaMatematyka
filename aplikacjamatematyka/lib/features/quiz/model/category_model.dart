class CategoryModel {
  final int id;
  final int classId;
  final String className;
  final String categoryName;
  final String description;
  final String iconUrl;
  final int displayOrder;

  CategoryModel({
    required this.id,
    required this.classId,
    required this.className,
    required this.categoryName,
    required this.description,
    required this.iconUrl,
    required this.displayOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      classId: json['class_fk'] ?? 0,
      className: json['class_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      displayOrder: json['display_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_fk': classId,
      'class_name': className,
      'category_name': categoryName,
      'description': description,
      'icon_url': iconUrl,
      'display_order': displayOrder,
    };
  }
}