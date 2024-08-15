class Category {
  final int? id;
  final String? categoryName;
  final String? categoryType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    this.id,
    this.categoryName,
    this.categoryType,
    this.createdAt,
    this.updatedAt,
  });

  // Convert a Category object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'categoryType': categoryType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert a JSON map into a Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int?,
      categoryName: json['category_name'],
      categoryType: json['category_type'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(
              json['created_at']) // Parse ISO 8601 string to DateTime
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(
              json['updated_at']) // Parse ISO 8601 string to DateTime
          : null,
    );
  }
}
