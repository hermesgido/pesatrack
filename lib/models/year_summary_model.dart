class YearSummary {
  final List<MonthSummary> yearSummary;

  YearSummary({required this.yearSummary});

  factory YearSummary.fromJson(Map<String, dynamic> json) {
    return YearSummary(
      yearSummary: List<MonthSummary>.from(
          json['year_summary'].map((month) => MonthSummary.fromJson(month))),
    );
  }
}

class MonthSummary {
  final String month;
  final MonthDetails monthSummary;
  final Map<String, DateSummary> transactionsByDate;

  MonthSummary({
    required this.month,
    required this.monthSummary,
    required this.transactionsByDate,
  });

  factory MonthSummary.fromJson(Map<String, dynamic> json) {
    return MonthSummary(
      month: json['month'],
      monthSummary: MonthDetails.fromJson(json['month_summary']),
      transactionsByDate: (json['transactions_by_date'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, DateSummary.fromJson(value))),
    );
  }
}

class MonthDetails {
  final double totalIncome;
  final double totalExpenses;
  final double balance;

  MonthDetails({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
  });

  factory MonthDetails.fromJson(Map<String, dynamic> json) {
    return MonthDetails(
      totalIncome: json['total_income'].toDouble(),
      totalExpenses: json['total_expenses'].toDouble(),
      balance: json['balance'].toDouble(),
    );
  }
}

class DateSummary {
  final double totalIncome;
  final double totalExpenses;
  final List<TransactionDetail> transactions;

  DateSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.transactions,
  });

  factory DateSummary.fromJson(Map<String, dynamic> json) {
    return DateSummary(
      totalIncome: json['total_income'].toDouble(),
      totalExpenses: json['total_expenses'].toDouble(),
      transactions: List<TransactionDetail>.from(json['transactions']
          .map((transaction) => TransactionDetail.fromJson(transaction))),
    );
  }
}

class TransactionDetail {
  final int id;
  final String transactionType;
  final String amount;
  final String description;
  final String transactionDate;
  final String category;

  TransactionDetail({
    required this.id,
    required this.transactionType,
    required this.amount,
    required this.description,
    required this.transactionDate,
    required this.category,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'],
      transactionType: json['transaction_type'],
      amount: json['amount'],
      description: json['description'],
      transactionDate: json['transaction_date'],
      category: json['category'],
    );
  }
}
