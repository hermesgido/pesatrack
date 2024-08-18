
class Budget {
  final int ? id;
  final String ? category;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
     this.id,
     this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category']['name'],
      amount: json['amount'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': {'name': category},
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
