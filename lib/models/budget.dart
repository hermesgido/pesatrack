import 'dart:ffi';

class Budget {
  final int? id;
  final double amount;
  final DateTime startDate;
  final DateTime endDate;
  final String? budgetName;
  final double? amountSpent;
  final double? amountRemaining;

  Budget({
    this.id,
    required this.amount,
    required this.startDate,
    required this.endDate,
    this.budgetName,
    this.amountSpent,
    this.amountRemaining,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
        id: json['id'],
        amount: double.parse(json['amount']),
        startDate: DateTime.parse(json['start_date'] ?? "2024-01-01"),
        endDate: DateTime.parse(json['end_date']),
        amountSpent: double.parse(json['amount_spent'] ?? "0.0"),
        amountRemaining: double.parse(json['amount_remaining'] ?? "0.0"),
        budgetName: json['name'] ?? "No Name");
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
