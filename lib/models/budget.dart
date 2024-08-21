class Budget {
  final int? id;
  final double? amount;
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
      amount: double.tryParse(json['amount']),
      startDate: DateTime.parse(json['start_date'] ?? "2024-01-01"),
      endDate: DateTime.parse(json['end_date']),
      amountSpent: (json['amount_spent'] as num?)?.toDouble() ?? 0.0,
      amountRemaining: (json['amount_remaining'] as num?)?.toDouble() ?? 0.0,
      budgetName: json['name'] ?? "No Name",
    );
  }

  // factory Budget.fromJson(Map<String, dynamic> json) {
  //   return Budget(
  //       id: json['id'],
  //       amount: double.parse(json['amount']),
  //       startDate: DateTime.parse(json['start_date'] ?? "2024-01-01"),
  //       endDate: DateTime.parse(json['end_date']),
  //       amountSpent: double.parse(json['amount_spent'] ?? "0.0"),
  //       amountRemaining: double.parse(json['amount_remaining'] ?? "0.0"),
  //       budgetName: json['name'] ?? "No Name");
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}

class YearBudgetSummary {
  List<MonthSummary> yearSummary;

  YearBudgetSummary({required this.yearSummary});

  factory YearBudgetSummary.fromJson(Map<String, dynamic> json) {
    return YearBudgetSummary(
      yearSummary: (json['year_summary'] as List)
          .map((month) => MonthSummary.fromJson(month))
          .toList(),
    );
  }
}

class MonthSummary {
  String month;
  MonthDetails monthDetails;
  List<Budget> budgets;

  MonthSummary({
    required this.month,
    required this.monthDetails,
    required this.budgets,
  });

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    return MonthSummary(
      month: json['month'],
      monthDetails: MonthDetails.fromJson(json['month_summary']),
      budgets: (json['budgets'] as List)
          .map((budget) => Budget.fromJson(budget))
          .toList(),
    );
  }
}

class MonthDetails {
  double totalBudgeted;
  double totalSpent;

  MonthDetails({required this.totalBudgeted, required this.totalSpent});

  factory MonthDetails.fromJson(Map<String, dynamic> json) {
    return MonthDetails(
      totalBudgeted: json['total_budgeted']?.toDouble() ?? 0.0,
      totalSpent: json['total_spent']?.toDouble() ?? 0.0,
    );
  }
}

// class Budget {
//   int id;
//   String name;
//   String? category;
//   double amount;
//   double amountSpent;
//   DateTime startDate;
//   DateTime endDate;

//   Budget({
//     required this.id,
//     required this.name,
//     this.category,
//     required this.amount,
//     required this.amountSpent,
//     required this.startDate,
//     required this.endDate,
//   });

//   factory Budget.fromJson(Map<String, dynamic> json) {
//     return Budget(
//       id: json['id'],
//       name: json['name'],
//       category: json['category'],
//       amount: double.parse(json['amount']),
//       amountSpent: json['amount_spent']?.toDouble() ?? 0.0,
//       startDate: DateTime.parse(json['start_date']),
//       endDate: DateTime.parse(json['end_date']),
//     );
//   }
// }
