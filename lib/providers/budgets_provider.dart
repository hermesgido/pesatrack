import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pesatrack/models/budget.dart';
import 'package:pesatrack/services/apiservice.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];
  bool _isLoading = false;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  Future<void> fetchBudgets() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.getBudgets();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _budgets = data.map((item) => Budget.fromJson(item)).toList();
      } else {
        print('Failed to load budgets');
      }
    } catch (error) {
      print('Error fetching budgets: $error');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBudget(Budget budget) async {
    try {
      final response = await _apiService.createBudget(budget);
      print(response.body);
      if (response.statusCode == 201) {
        final newBudget = Budget.fromJson(jsonDecode(response.body));
        _budgets.add(newBudget);
        notifyListeners();
      } else {
        print('Failed to create budget');
      }
    } catch (error) {
      print('Error creating budget: $error');
    }
  }

  Future<void> updateBudget(int id, Budget budget) async {
    try {
      final response = await _apiService.updateBudget(id, budget.toJson());
      if (response.statusCode == 200) {
        final updatedBudget = Budget.fromJson(jsonDecode(response.body));
        final index = _budgets.indexWhere((b) => b.id == id);
        if (index != -1) {
          _budgets[index] = updatedBudget;
          notifyListeners();
        }
      } else {
        print('Failed to update budget');
      }
    } catch (error) {
      print('Error updating budget: $error');
    }
  }

  Future<void> deleteBudget(int id) async {
    try {
      final response = await _apiService.deleteBudget(id);
      if (response.statusCode == 204) {
        _budgets.removeWhere((b) => b.id == id);
        notifyListeners();
      } else {
        print('Failed to delete budget');
      }
    } catch (error) {
      print('Error deleting budget: $error');
    }
  }
}
