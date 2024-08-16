import 'package:flutter/material.dart';
import 'package:pesatrack/models/year_summary_model.dart';
import 'package:pesatrack/services/apiservice.dart';

class YearSummaryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  YearSummary? _yearSummary;
  bool _isLoading = false;
  String? _errorMessage;

  YearSummary? get yearSummary => _yearSummary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchYearSummary(int year) async {
    print("im hereeeeeeeeeeeeeee");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    // await Future.delayed(const Duration(hours: 1));
    try {
      YearSummary summary = await _apiService.getYearSummary(year);
      print(summary);
      print("ddddddddddddddddddd");
      _yearSummary = summary;
    } catch (error) {
      print(error);
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  int _currentMonthIndex = DateTime.now().month - 1;

  String get selectedMonth =>
      _yearSummary?.yearSummary[_currentMonthIndex].month ?? '';
  double get totalIncome =>
      _yearSummary?.yearSummary[_currentMonthIndex].monthSummary.totalIncome ??
      0.0;
  double get totalExpenses =>
      _yearSummary
          ?.yearSummary[_currentMonthIndex].monthSummary.totalExpenses ??
      0.0;
  double get balance =>
      _yearSummary?.yearSummary[_currentMonthIndex].monthSummary.balance ?? 0.0;

  Map<String, DateSummary> get transactionsByDate =>
      _yearSummary?.yearSummary[_currentMonthIndex].transactionsByDate ?? {};

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
