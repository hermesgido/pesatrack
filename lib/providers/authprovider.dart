import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pesatrack/main.dart';
import 'package:pesatrack/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pesatrack/utils/urls.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuthentication(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Send a request to the backend to verify the token
      final response = await http.post(
        Uri.parse('$baseUrl/api/token/verify/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'token': token}),
      );

      if (response.statusCode == 200) {
        // Token is valid
        _isAuthenticated = true;
      } else {
        // Token is invalid or expired
        _isAuthenticated = false;
        prefs.remove('token'); // Optionally remove the token if invalid
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => const LoginPage()),
        //     (Route<dynamic> route) => false,
        //   );
        // });
      }
    } else {
      _isAuthenticated = false;
    }

    notifyListeners();
  }

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please fill all fields');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': email,
          'password': password,
        }),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 201) {
        // Registration successful
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token']; // Adjust if your token key differs
        print('Token received: $token');

        // Store token in Shared Preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Ensure the context is valid
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MyApp()),
            (Route<dynamic> route) => false,
          );
        });
      } else {
        final responseBody = jsonDecode(response.body);
        print('Error response: $responseBody');
        throw Exception(responseBody['detail'] ?? 'Registration failed');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      throw Exception('An error occurred: $error');
    }
  }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please fill all fields');
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('$baseUrl/api/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': email,
        'password': password,
      }),
    );

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final token =
          responseBody['access']; // Assume token is returned in the response
      print(responseBody);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (Route<dynamic> route) => false,
      );
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['detail'] ?? 'Login failed');
    }
  }
}
