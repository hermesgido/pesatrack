import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pesatrack/providers/fee_Provider.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';

class TransferTab extends StatefulWidget {
  final String action;

  const TransferTab({super.key, required this.action});

  @override
  _TransferTabState createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  var changedFrom = list.first;
  var changedTo = list.first;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeeProvider>(context);
    return Padding(
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
                      child: SizedBox(
                        height: 70,
                        child: DropdownMenuExample(
                          btnLabel: 'From',
                          onChanged: (value) {
                            changedFrom = value!;
                            print(value);
                            print("Changed noww to");
                          },
                        ),
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
                        controller: feeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Garama",
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 70,
                        child: DropdownMenuExample(
                          btnLabel: 'To',
                          onChanged: (value) {
                            changedTo = value!;
                          },
                        ),
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
                      print(amount);
                      print(
                          "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
                      if (amount != null) {
                        await provider.calculateFee(
                          amount: amount,
                          action: widget.action,
                          mnoFrom: changedFrom,
                          mnoTo: changedTo,
                        );
                        // Update fee field after calculation
                        if (provider.fee != null) {
                          feeController.text = provider.fee.toString();
                        }
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
                          ? customLoadingIndicator(context)
                          : const Text(
                              'Calculate',
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
    );
  }
}

class WithdrawTab extends StatefulWidget {
  final String action;

  WithdrawTab({required this.action});

  @override
  _WithdrawTabState createState() => _WithdrawTabState();
}

class _WithdrawTabState extends State<WithdrawTab> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

  var changedFrom = list.first;
  var changedTo = list.first;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeeProvider>(context);
    return Padding(
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
                      child: SizedBox(
                        height: 70,
                        child: DropdownMenuExample(
                          btnLabel: 'From',
                          onChanged: (value) {
                            print(value);

                            changedFrom = value!;

                            print("Changed noww to");
                          },
                        ),
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
                        controller: feeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          labelText: "Garama",
                        ),
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
                      if (amount != null) {
                        await provider.calculateFee(
                          amount: amount,
                          action: widget.action,
                          mnoFrom: changedFrom,
                        );
                        // Update fee field after calculation
                        if (provider.fee != null) {
                          feeController.text = provider.fee.toString();
                        }
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
                          ? customLoadingIndicator(context)
                          : const Text(
                              'Calculate',
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
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.btnLabel,
        border: InputBorder.none, // Remove borders
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          isExpanded: true,
          onChanged: (String? value) {
            if (value != null) {
              setState(() {
                dropdownValue = value;
              });
              widget.onChanged(value); // Ensure this line is called
            }
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

const List<String> list = <String>[
  'M-Pesa',
  'Airtel Money',
  'Tigopesa',
  'Halopesa'
];

class TransferCharges extends StatelessWidget {
  const TransferCharges({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Transfer Charges',
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Transfer'),
                Tab(text: 'Withdraw'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TransferTab(action: "send"),
              WithdrawTab(action: "withdraw")
            ],
          ),
        ),
      ),
    );
  }
}
