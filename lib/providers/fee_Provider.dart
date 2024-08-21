import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pesatrack/services/apiservice.dart';

class FeeProvider extends ChangeNotifier {
  double? fee;
  bool isLoading = false;
  String errorMessage = '';
  final ApiService _apiService = ApiService();

  Future<void> calculateFee({
    required double amount,
    required String action,
    required String mnoFrom,
    String? mnoTo,
  }) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    String convertMno(String mno) {
      switch (mno) {
        case 'M-Pesa':
          return 'mpesa';
        case 'Airtel Money':
          return 'airtel';
        case 'Tigopesa':
          return 'tigopesa';
        case 'Halopesa':
          return 'halopesa';
        default:
          return mno.toLowerCase(); // Fallback in case of unrecognized value
      }
    }

    try {
      String convertMno(String mno) {
        switch (mno) {
          case 'M-Pesa':
            return 'mpesa';
          case 'Airtel Money':
            return 'airtel';
          case 'Tigopesa':
            return 'tigo';
          case 'Halopesa':
            return 'halopesa';
          default:
            return mno.toLowerCase();
        }
      }

      final response = await _apiService.calculateMnoFee({
        'amount': amount,
        'action': action,
        'mno_from': convertMno(mnoFrom),
        if (mnoTo != null) 'mno_to': convertMno(mnoTo),
      });

      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        fee = data['fee'];
      } else {
        errorMessage = 'Failed to calculate fee.';
      }
    } catch (e) {
      errorMessage = 'An error occurred: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
