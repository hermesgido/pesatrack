import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pesatrack/models/budget.dart';
import 'package:pesatrack/models/year_summary_model.dart';
import 'package:pesatrack/utils/headers.dart';
import 'package:pesatrack/utils/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getToken() async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    print(token);
    // final prefs = await SharedPreferences.getInstance();
    return token;
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
    print(response.body);

    return response;
  }

  Future<http.Response> createCategory(
      String name, String selectedCategoryType) async {
    print(await getToken());
    final response = await http.post(
      Uri.parse('$baseUrl/api/categories/'),
      headers: await getHeaders(),
      body: jsonEncode(
          {'category_name': name, 'category_type': selectedCategoryType}),
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

  Future<http.Response> updateCategory(
      int id, String name, String selectedCategoryType) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/categories/$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'category_type': selectedCategoryType}),
    );
    return response;
  }

  Future<http.Response> deleteCategory(int id) async {
    final response = await http.delete(
        Uri.parse('$baseUrl/api/categories/$id/'),
        headers: await getHeaders());
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

  // // List and Create Budgets
  // Future<http.Response> getBudgets() async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/budgets/'),
  //   );
  //   return response;
  // }

  // Future<http.Response> createBudget(String name, double amount) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/api/budgets/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'name': name, 'amount': amount}),
  //   );
  //   return response;
  // }

  // // Retrieve, Update, and Delete Budget
  // Future<http.Response> getBudget(int id) async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/budgets/$id/'),
  //   );
  //   return response;
  // }

  // Future<http.Response> updateBudget(int id, String name, double amount) async {
  //   final response = await http.put(
  //     Uri.parse('$baseUrl/api/budgets/$id/'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'name': name, 'amount': amount}),
  //   );
  //   return response;
  // }

  // Future<http.Response> deleteBudget(int id) async {
  //   final response = await http.delete(
  //     Uri.parse('$baseUrl/api/budgets/$id/'),
  //   );
  //   return response;
  // }

  // Future<String?> getToken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.getString('token');
  // }

  Future<http.Response> getBudgets() async {
    return await http.get(Uri.parse('$baseUrl/api/budgets/'),
        headers: await getHeaders());
  }

  Future<http.Response> createBudget([Budget? budget]) async {
    print("object");
    print(budget!.categoryId);
    print(budget.startDate);
    print("object");
    print('$baseUrl/api/budgets/');
    print(jsonEncode({
      "start_date": budget.startDate.toString(),
      "end_date": budget.endDate.toString(),
      "amount": budget.amount,
      "name": budget.budgetName,
      "category": budget.categoryId
    }));
    return await http.post(
      Uri.parse('$baseUrl/api/budgets/'),
      headers: await getHeaders(),
      body: jsonEncode({
        "start_date": budget.startDate.toString(),
        "end_date": budget.endDate.toString(),
        "amount": budget.amount,
        "name": budget.budgetName,
        "category": budget.categoryId.toString()
      }),
    );
  }

  Future<http.Response> updateBudget(
      int id, Map<String, dynamic> budgetData) async {
    return await http.put(
      Uri.parse('$baseUrl/api/budgets/$id/'),
      headers: await getHeaders(),
      body: jsonEncode(budgetData),
    );
  }

  Future<http.Response> deleteBudget(int id) async {
    return await http.delete(Uri.parse('$baseUrl/api/budgets/$id/'),
        headers: await getHeaders());
  }

  // Shared Preferences for Storing JWT Token

  Future<YearSummary> getYearSummary(int year) async {
    final url = Uri.parse('$baseUrl/api/year-summary/2024');
    final response = await http.get(url, headers: await getHeaders());
    print(response.body);

    // if (response.statusCode == 200) {
    // Parse the JSON data into your model
    return YearSummary.fromJson(json.decode(response.body));
    //   } else {
    //     throw Exception('Failed to load year summary');
    //   }
  }

  Future<http.Response> calculateMnoFee(Map<String, Object> map) async {
    final url = Uri.parse('$baseUrl/api/calculate-fee/');
    return await http.post(
      url,
      headers: await getHeaders(),
      body: jsonEncode(map),
    );
  }

  Future<YearBudgetSummary> getYearlyBudgetSummary(int year) async {
    final url = Uri.parse('$baseUrl/api/budgets/summary/2024/');
    print(url);

    final response = await http.get(url, headers: await getHeaders());
    print(response.body);
    print("Unanona sasaaaaaaaaaaa");
    return YearBudgetSummary.fromJson(jsonDecode(response.body));

    // try {
    //   final response = await http.get(url, headers: await getHeaders());
    //   print(response.body);
    //   print("Unanona sasaaaaaaaaaaa");

    //   if (response.statusCode == 200) {
    //     return YearBudgetSummary.fromJson(jsonDecode(response.body));
    //   } else {
    //     throw Exception('Failed to load yearly budget summary');
    //   }
    // } catch (e) {
    //   throw Exception('Error fetching data: $e');
    // }
  }
}
