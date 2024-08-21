import 'package:flutter/material.dart';
import 'package:pesatrack/providers/forex_provider.dart';
import 'package:provider/provider.dart';

class ForexExchangePage extends StatefulWidget {
  @override
  _ForexExchangePageState createState() => _ForexExchangePageState();
}

class _ForexExchangePageState extends State<ForexExchangePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController exchangedAmountController =
      TextEditingController();

  String? selectedFromCurrency;
  String? selectedToCurrency;

  @override
  void initState() {
    super.initState();
    // Optionally initialize the provider or fetch default data here
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExchangeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Forex Exchange'),
        backgroundColor: Color(0xFF6D53F4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Amount",
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownMenuExample(
                          btnLabel: 'From Currency',
                          onChanged: (value) {
                            setState(() {
                              selectedFromCurrency = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 119, 119, 119),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: exchangedAmountController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Exchanged Amount",
                          ),
                        ),
                      ),
                      Expanded(
                        child: DropdownMenuExample(
                          btnLabel: 'To Currency',
                          onChanged: (value) {
                            setState(() {
                              selectedToCurrency = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount = double.tryParse(amountController.text);
                        if (amount != null &&
                            selectedFromCurrency != null &&
                            selectedToCurrency != null) {
                          await provider.calculateExchangeRate(
                            amount: amount,
                            fromCurrency: selectedFromCurrency!,
                            toCurrency: selectedToCurrency!,
                          );
                          // Update exchanged amount field after calculation
                          if (provider.exchangedAmount != null) {
                            exchangedAmountController.text =
                                provider.exchangedAmount.toString();
                          }
                        } else {
                          print(
                              'Validation failed. Amount: $amount, From: $selectedFromCurrency, To: $selectedToCurrency');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D53F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: provider.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Convert',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  final String btnLabel;
  final ValueChanged<String?> onChanged;

  const DropdownMenuExample({
    super.key,
    required this.btnLabel,
    required this.onChanged,
  });

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = currencies.first; // Example value

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      hint: Text(widget.btnLabel),
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            dropdownValue = value;
          });
          widget.onChanged(value); // Call the callback
        }
      },
      items: currencies.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// Dummy list of currencies for the dropdown menu
const List<String> currencies = <String>[
  'USD',
  'EUR',
  'JPY',
  'GBP',
  'AUD',
  'CAD',
  'CHF',
  'CNY',
  'SEK',
  'NZD',
];
