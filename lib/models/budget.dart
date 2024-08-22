import 'package:pesatrack/models/category.dart';

class Budget {
  final int? id;
  final String? amount;
  final Category? category;
  final String? categoryId;
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
    this.categoryId,
    this.category,
    this.budgetName,
    this.amountSpent,
    this.amountRemaining,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      budgetName: json['name'],
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      amount: json['amount'].toString(),
      amountSpent: json['amount_spent'].toDouble(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {};
  }
}

class YearBudgetSummary {
  final List<MonthSummary> yearSummary;

  YearBudgetSummary({required this.yearSummary});

  factory YearBudgetSummary.fromJson(Map<String, dynamic> json) {
    return YearBudgetSummary(
      yearSummary: (json['year_summary'] as List)
          .map((monthJson) => MonthSummary.fromJson(monthJson))
          .toList(),
    );
  }
}

class MonthSummary {
  final String month;
  final MonthSummaryDetails monthSummary;
  final Map<String, BudgetByDate> budgetsByDate;

  MonthSummary({
    required this.month,
    required this.monthSummary,
    required this.budgetsByDate,
  });

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    var budgetsByDateJson = json['budgets_by_date'] as Map<String, dynamic>;
    Map<String, BudgetByDate> budgetsByDate = budgetsByDateJson.map(
      (date, budgetJson) => MapEntry(date, BudgetByDate.fromJson(budgetJson)),
    );

    return MonthSummary(
      month: json['month'],
      monthSummary: MonthSummaryDetails.fromJson(json['month_summary']),
      budgetsByDate: budgetsByDate,
    );
  }
}

class MonthSummaryDetails {
  final double totalBudgeted;
  final double totalSpent;

  MonthSummaryDetails({
    required this.totalBudgeted,
    required this.totalSpent,
  });

  factory MonthSummaryDetails.fromJson(Map<String, dynamic> json) {
    return MonthSummaryDetails(
      totalBudgeted: json['total_budgeted'].toDouble(),
      totalSpent: json['total_spent'].toDouble(),
    );
  }
}

class BudgetByDate {
  final double totalBudget;
  final double totalSpent;
  final List<Budget> budgets;

  BudgetByDate({
    required this.totalBudget,
    required this.totalSpent,
    required this.budgets,
  });

  factory BudgetByDate.fromJson(Map<String, dynamic> json) {
    return BudgetByDate(
      totalBudget: json['total_budget'].toDouble(),
      totalSpent: json['total_spent'].toDouble(),
      budgets: (json['budgets'] as List)
          .map((budgetJson) => Budget.fromJson(budgetJson))
          .toList(),
    );
  }
}

// class Budget {
//   final int id;
//   final String name;
//   final String category;
//   final String amount;
//   final double amountSpent;
//   final DateTime startDate;
//   final DateTime endDate;

//   var budgetName;

//   Budget({
//     required this.id,
//     required this.name,
//     required this.category,
//     required this.amount,
//     required this.amountSpent,
//     required this.startDate,
//     required this.endDate,
//   });














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
