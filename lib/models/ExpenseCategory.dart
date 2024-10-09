// models/expense_category.dart
class ExpenseCategory {
  final String categoryName;
  final double totalSpent;
  final double percentage;

  ExpenseCategory({
    required this.categoryName,
    required this.totalSpent,
    required this.percentage,
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      categoryName: json['category_name'],
      totalSpent: json['total_spent'].toDouble(),
      percentage: json['percentage'].toDouble(),
    );
  }
}
