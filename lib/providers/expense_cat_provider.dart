// providers/expense_provider.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pesatrack/models/ExpenseCategory.dart';
import 'package:pesatrack/utils/headers.dart';
import 'dart:convert';
import 'package:pesatrack/utils/urls.dart';

class ExpenseCategoryProvider with ChangeNotifier {
  List<ExpenseCategory> _categories = [];

  List<ExpenseCategory> get categories => _categories;

  Future<void> fetchExpenseCategories() async {
  
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/category-expense-summary/'), headers: await getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _categories =
            data.map((json) => ExpenseCategory.fromJson(json)).toList();
        notifyListeners();
      } else {
        Fluttertoast.showToast(
          msg: response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0,
        );
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }
}
