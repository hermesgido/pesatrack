import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ExchangeProvider with ChangeNotifier {
  double? exchangedAmount;
  bool isLoading = false;

  Future<void> calculateExchangeRate({
    required double amount,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
        'https://www.freeforexapi.com/api/live?pairs=${fromCurrency.toUpperCase()}${toCurrency.toUpperCase()}',
      ));
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = data['rates']
            [fromCurrency.toUpperCase() + toCurrency.toUpperCase()]['rate'];
        exchangedAmount = amount * rate;
      } else {
        throw Exception('Failed to load exchange rate');
      }
    } catch (e) {
      print('Error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
