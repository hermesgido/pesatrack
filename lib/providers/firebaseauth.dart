import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Login Method
  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    setLoading(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      throw Exception(e.message);
    }
  }

  // Register Method
  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    setLoading(true);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      setLoading(false);
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      throw Exception(e.message);
    }
  }

  // Sign out method
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Google Sign-In (optional) - can be added here

  User? get currentUser => _firebaseAuth.currentUser;
}
