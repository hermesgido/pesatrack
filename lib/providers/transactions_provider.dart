import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pesatrack/models/transaction.dart';
import 'package:pesatrack/models/transaction_summary.dart';
import 'package:pesatrack/services/apiservice.dart';

class TransactionsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  TransactionSummary? _transactionSummary;

  TransactionSummary? get transactionSummary => _transactionSummary;

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    print("jeeeeeeeeeeeeeeeeeee");
    try {
      // await Future.delayed(Duration(minutes: 1));

      final response = await _apiService.getTransactions();

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _transactions = data.map((item) => Transaction.fromJson(item)).toList();
      } else {
        _handleError(response);
      }
    } catch (error) {
      _handleException(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTransaction({
    required String name,
    required double amount,
    required String date,
    required String category,
    required String description,
    required transactionType,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.createTransaction(
          amount, date, category, description, transactionType);

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        print(json);
        final newTransaction = Transaction.fromJson(json);
        _transactions.insert(0, newTransaction);
        await fetchTransactionsHomePage();
        notifyListeners();
      } else {
        _handleError(response);
      }
    } catch (error) {
      _handleException(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction(
      {required double amount,
      required String date,
      required String description,
      required String category,
      required int id}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.updateTransaction(
          id, amount, date, category, description);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final updatedTransaction = Transaction.fromJson(json);
        _transactions = _transactions
            .map((t) => t.id == id ? updatedTransaction : t)
            .toList();
      } else {
        _handleError(response);
      }
    } catch (error) {
      _handleException(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.deleteTransaction(id);
      if (response.statusCode == 204) {
        _transactions.removeWhere((t) => t.id == id);
        await fetchTransactionsHomePage();
        notifyListeners();
      } else {
        _handleError(response);
      }
    } catch (error) {
      _handleException(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTransactionsHomePage() async {
    print("in summaryyy");

    _isLoading = false;
    // notifyListeners();
    try {
      final response = await _apiService.getTransactionAnalyicsHomePage();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _transactionSummary = TransactionSummary.fromJson(data);
      } else {
        _handleError(response);
      }
    } catch (error) {
      _handleException(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleError(response) {
    // Implement your error handling here, such as showing a snackbar or logging
    print('Error: ${response.statusCode} - ${response.reasonPhrase}');
  }

  void _handleException(error) {
    // Implement your exception handling here
    print('Exception: $error');
  }
}
