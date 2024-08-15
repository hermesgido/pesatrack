import 'package:pesatrack/models/category.dart';

class Transaction {
  int? id;
  final String? transactionType;
  final String? amount;
  final Category? category;
  final String? description;
  final DateTime? transactionDate;

  Transaction(
      {this.id,
      this.transactionType,
      this.amount,
      this.description,
      this.transactionDate,
      this.category});

  // Convert a Transaction object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'transactionType': transactionType,
      'amount': amount,
      'description': description,
      'transactionDate': transactionDate?.toIso8601String(),
    };
  }

  // Convert a JSON map into a Transaction object
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        id: json['id'],
        transactionType: json['transaction_type'],
        amount: (json['amount']),
        description: json['description'],
        transactionDate: json['transaction_date'] != null
            ? DateTime.parse(json['transaction_date'])
            : null,
        category: Category.fromJson(json['category']));
  }
}
