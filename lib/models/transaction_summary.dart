class TransactionSummary {
  final SummaryData today;
  final SummaryData yesterday;
  final SummaryData thisWeek;
  final SummaryData thisMonth;
  final SummaryData thisYear;

  TransactionSummary({
    required this.today,
    required this.yesterday,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
  });

  // Factory method to create a TransactionSummary from JSON
  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      today: SummaryData.fromJson(json['today']),
      yesterday: SummaryData.fromJson(json['yesterday']),
      thisWeek: SummaryData.fromJson(json['this_week']),
      thisMonth: SummaryData.fromJson(json['this_month']),
      thisYear: SummaryData.fromJson(json['this_year']),
    );
  }
}

class SummaryData {
  final double totalIncome;
  final double totalExpense;
  final double totalBalance;

  SummaryData({
    required this.totalIncome,
    required this.totalExpense,
    required this.totalBalance,
  });

  // Factory method to create a SummaryData from JSON
  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      totalIncome: json['total_income'].toDouble(),
      totalExpense: json['total_expense'].toDouble(),
      totalBalance: json['total_balance'].toDouble(),
    );
  }
}
