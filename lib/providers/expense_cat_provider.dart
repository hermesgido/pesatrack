// providers/expense_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pesatrack/models/ExpenseCategory.dart';
import 'dart:convert';
import 'package:pesatrack/utils/urls.dart';

class ExpenseCategoryProvider with ChangeNotifier {
  List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  Future<void> fetchExpenseCategories() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/category-expense-summary/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _categories = data.map((json) => ExpenseCategory.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
