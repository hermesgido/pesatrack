import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pesatrack/services/apiservice.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<dynamic> _categories = [];
  bool _isLoading = false;

  List<dynamic> get categories => _categories;
  bool get isLoading => _isLoading;

  // Function to load categories from the API
  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCategories();
      if (response.statusCode == 200) {
        _categories = jsonDecode(response.body);
        print(_categories);
      } else {
        // Handle error
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to add a new category
  Future<void> addCategory(String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.createCategory(name);
      if (response.statusCode == 201) {
        _categories.add(jsonDecode(response.body));
      } else {
        // Handle error
        throw Exception('Failed to add category');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to delete a category
  Future<void> deleteCategory(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.deleteCategory(id);
      if (response.statusCode == 204) {
        _categories.removeWhere((category) => category['id'] == id);
      } else {
        // Handle error
        throw Exception('Failed to delete category');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to update a category
  Future<void> updateCategory(int id, String name) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.updateCategory(id, name);
      if (response.statusCode == 200) {
        int index = _categories.indexWhere((category) => category['id'] == id);
        if (index != -1) {
          _categories[index] = jsonDecode(response.body);
        }
      } else {
        // Handle error
        throw Exception('Failed to update category');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
