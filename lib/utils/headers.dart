import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<Map<String, String>> getHeaders() async {
  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${await getToken()}',
  };

  return headers;
}
