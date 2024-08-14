import 'package:shared_preferences/shared_preferences.dart';

class TokenHandler {
  static const String _tokenKey = 'authToken';

  String? _token;

  TokenHandler({String? token}) : _token = token;

  String? get token => _token;

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<bool> hasToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    return _token != null && _token!.isNotEmpty;
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  bool isTokenValid() {
    // Add your token validation logic here
    // Example: Check token expiry date or call an API to validate the token
    return true; // Return true for now as this is just a basic example
  }

  Future<void> setUserID(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", userId);
  }

  Future getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");
  }
}
