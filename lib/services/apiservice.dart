import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pesatrack/models/year_summary_model.dart';
import 'package:pesatrack/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await getToken()}',
    };

    return headers;
  }

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // User Registration
  Future<http.Response> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return response;
  }

  // Obtain JWT Token
  Future<http.Response> obtainToken(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/token/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    return response;
  }

  // Refresh JWT Token
  Future<http.Response> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );
    return response;
  }

  // Verify JWT Token
  Future<http.Response> verifyToken(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/token/verify/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );
    return response;
  }

  // List and Create Accounts
  Future<http.Response> getAccounts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/accounts/'),
    );
    return response;
  }

  Future<http.Response> createAccount(String name, double balance) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/accounts/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'balance': balance}),
    );
    return response;
  }

  // Retrieve, Update, and Delete Account
  Future<http.Response> getAccount(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/accounts/$id/'),
    );
    return response;
  }

  Future<http.Response> updateAccount(
      int id, String name, double balance) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/accounts/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'balance': balance}),
    );
    return response;
  }

  Future<http.Response> deleteAccount(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/accounts/$id/'),
    );
    return response;
  }

  // List and Create Categories
  Future<http.Response> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories/'),
        headers: await getHeaders());
    return response;
  }

  Future<http.Response> createCategory(String name) async {
    print(await getToken());
    final response = await http.post(
      Uri.parse('$baseUrl/api/categories/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}',
      },
      body: jsonEncode({'name': name}),
    );
    return response;
  }

  // Retrieve, Update, and Delete Category
  Future<http.Response> getCategory(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories/$id/'),
    );
    return response;
  }

  Future<http.Response> updateCategory(int id, String name) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/categories/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    return response;
  }

  Future<http.Response> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/categories/$id/'),
    );
    return response;
  }

  // List and Create Transactions
  Future<http.Response> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/transactions/'),
      headers: await getHeaders(),
    );
    print(baseUrl);
    return response;
  }

  Future<http.Response> createTransaction(double amount, String date,
      String category, String description, transactionType) async {
    final body = jsonEncode({
      'amount': amount,
      'transaction_date': date,
      'category': category,
      'description': description,
      'transaction_type': transactionType.toLowerCase()
    });
    print(body);
    final response = await http.post(
      Uri.parse('$baseUrl/api/transactions/'),
      headers: await getHeaders(),
      body: body,
    );
    return response;
  }

  // Retrieve, Update, and Delete Transaction
  Future<http.Response> getTransaction(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/transactions/$id/'),
    );
    return response;
  }

  Future<http.Response> updateTransaction(int id, double amount, String date,
      String category, String description) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/transactions/$id/'),
      headers: await getHeaders(),
      body: jsonEncode({
        'amount': amount,
        'date': date,
        'category': category,
        'description': description,
      }),
    );
    return response;
  }

  Future<http.Response> deleteTransaction(int id) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/api/transactions/$id/'),
        headers: await getHeaders());
    return response;
  }

  Future<http.Response> getTransactionAnalyicsHomePage() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/transactions/analytics'),
      headers: await getHeaders(),
    );
    return response;
  }

  // List and Create Budgets
  Future<http.Response> getBudgets() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/budgets/'),
    );
    return response;
  }

  Future<http.Response> createBudget(String name, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/budgets/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'amount': amount}),
    );
    return response;
  }

  // Retrieve, Update, and Delete Budget
  Future<http.Response> getBudget(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/budgets/$id/'),
    );
    return response;
  }

  Future<http.Response> updateBudget(int id, String name, double amount) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/budgets/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'amount': amount}),
    );
    return response;
  }

  Future<http.Response> deleteBudget(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/budgets/$id/'),
    );
    return response;
  }

  // Shared Preferences for Storing JWT Token

  Future<YearSummary> getYearSummary(int year) async {
    final response = await http.get(Uri.parse('$baseUrl/api/year-summary/2024'));
    print(response.body);

    if (response.statusCode == 200) {
      print(response);
      print("Unanona sasaaaaaaaaaaa");
      // Parse the JSON data into your model
      return YearSummary.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load year summary');
    }
  }
}
