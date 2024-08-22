import 'package:flutter/material.dart';
import 'package:pesatrack/models/budget.dart';
import 'package:pesatrack/services/apiservice.dart';

class YearBudgetSummaryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  YearBudgetSummary? _yearSummary;
  bool _isLoading = false;
  String? _errorMessage;

  YearBudgetSummary? get yearSummary => _yearSummary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchYearSummary(int year) async {
    print("im hereeeeeeeeeeeeeee");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    // await Future.delayed(const Duration(hours: 1));
    // try {
    YearBudgetSummary summary = await _apiService.getYearlyBudgetSummary(year);
    print(summary);
    print("ddddddddddddddddddd");
    _yearSummary = summary;
    // } catch (error) {
    //   print(error);
    //   _errorMessage = error.toString();
    // }

    _isLoading = false;
    notifyListeners();
  }

  int _currentMonthIndex = DateTime.now().month - 1;

  String get selectedMonth =>
      _yearSummary?.yearSummary[_currentMonthIndex].month ?? '';
  double get totolBudgeted =>
      _yearSummary
          ?.yearSummary[_currentMonthIndex].monthSummary.totalBudgeted ??
      0.0;
  double get totalSpent =>
      _yearSummary?.yearSummary[_currentMonthIndex].monthSummary.totalSpent ??
      0.0;
  double get balance =>
      _yearSummary
          ?.yearSummary[_currentMonthIndex].monthSummary.totalBudgeted ??
      0.0;

  Map<String, BudgetByDate> get budgetsByDate =>
      _yearSummary?.yearSummary[_currentMonthIndex].budgetsByDate ?? {};

  void nextMonth() {
    if (_yearSummary != null &&
        _currentMonthIndex < _yearSummary!.yearSummary.length - 1) {
      _currentMonthIndex++;
      notifyListeners();
    }
  }

  void previousMonth() {
    if (_currentMonthIndex > 0) {
      _currentMonthIndex--;
      notifyListeners();
    }
  }
}







// import 'package:flutter/material.dart';
// import 'package:pesatrack/models/budget.dart';
// import 'package:pesatrack/services/apiservice.dart';

// class YearBudgetSummaryProvider with ChangeNotifier {
//   final ApiService _apiService = ApiService();
//   YearBudgetSummary? _yearSummary;
//   bool _isLoading = false;
//   String? _errorMessage;

//   YearBudgetSummary? get yearSummary => _yearSummary;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   int _currentMonthIndex = DateTime.now().month - 1;

//   String get selectedMonth =>
//       _yearSummary?.yearSummary[_currentMonthIndex].month ?? '';
//   double get totalBudgeted =>
//       _yearSummary
//           ?.yearSummary[_currentMonthIndex].monthDetails.totalBudgeted ??
//       0.0;
//   double get totalSpent =>
//       _yearSummary?.yearSummary[_currentMonthIndex].monthDetails.totalSpent ??
//       0.0;

//   List<Budget>? get transactionsByDate => _yearSummary?.yearSummary[8].budgets;

//   void nextMonth() {
//     if (_yearSummary != null &&
//         _currentMonthIndex < _yearSummary!.yearSummary.length - 1) {
//       _currentMonthIndex++;
//       notifyListeners();
//     }
//   }

//   void previousMonth() {
//     if (_currentMonthIndex > 0) {
//       _currentMonthIndex--;
//       notifyListeners();
//     }
//   }

//   Future<void> fetchYearBudgetSummary(int year) async {
//     _isLoading = true;
//     _errorMessage = null;
//     // notifyListeners();

//     try {
//       YearBudgetSummary summary =
//           await _apiService.getYearlyBudgetSummary(year);
//       await Future.delayed(const Duration(seconds: 5));

//       _yearSummary = summary;
//     } catch (error) {
//       _errorMessage = error.toString();
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
