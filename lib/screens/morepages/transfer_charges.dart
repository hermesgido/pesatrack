import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pesatrack/providers/fee_Provider.dart';
import 'package:provider/provider.dart';

class TransferTab extends StatefulWidget {
  final String action;

  TransferTab({required this.action});

  @override
  _TransferTabState createState() => _TransferTabState();
}

class _TransferTabState extends State<TransferTab> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController feeController = TextEditingController();

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
                    const Expanded(
                      child: DropdownMenuExample(btnLabel: 'From'),
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
                    const Expanded(
                      child: DropdownMenuExample(btnLabel: 'To'),
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
                          mnoFrom:
                              list.first, // Replace with actual selection logic
                          mnoTo:
                              list.first, // Replace with actual selection logic
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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
                    const Expanded(
                      child: DropdownMenuExample(btnLabel: 'From'),
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
                          mnoFrom:
                              list.first, // Replace with actual selection logic
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
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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

// Custom dropdown menu
class DropdownMenuExample extends StatefulWidget {
  final String btnLabel;

  const DropdownMenuExample({
    super.key,
    required this.btnLabel,
  });

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      menuHeight: 400,
      inputDecorationTheme:
          const InputDecorationTheme(isDense: true, border: InputBorder.none),
      label: Text(widget.btnLabel),
      initialSelection: list.first,
      onSelected: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
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
              WithdrawTab(action: "withdaw")
            ],
          ),
        ),
      ),
    );
  }
}

// class TransferCharges extends StatelessWidget {
//   const TransferCharges({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2, // Number of tabs
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(
//               'Transfer Charges',
//               style: GoogleFonts.montserrat(
//                   fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: 'Transfer'),
//                 Tab(text: 'Withdraw'),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).canvasColor,
//                           borderRadius: BorderRadius.circular(12)),
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         label: Text("Kiasi"),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                   child: Column(
//                                 children: [
//                                   DropdownMenuExample(
//                                     btnLabel: "From",
//                                   ),
//                                 ],
//                               ))
//                             ],
//                           ),
//                           const Divider(
//                             color: Color.fromARGB(255, 119, 119, 119),
//                           ),
//                           Row(
//                             children: [
//                               const Expanded(
//                                 child: Column(
//                                   children: [
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         label: Text("Garama"),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                   child: Column(
//                                 children: [
//                                   DropdownMenuExample(
//                                     btnLabel: "T",
//                                   )
//                                   // DropdownMenuExample(
//                                   //   btnLabel: 'To',
//                                   // )
//                                 ],
//                               ))
//                             ],
//                           ),
//                           const SizedBox(height: 12),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6D53F4),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15),
//                                 child: Text(
//                                   'Calculate',
//                                   style: GoogleFonts.inter(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 28),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                           color: Theme.of(context).canvasColor,
//                           borderRadius: BorderRadius.circular(12)),
//                       padding: const EdgeInsets.all(8),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   children: [
//                                     TextField(
//                                       decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         label: Text("Kiasi"),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Expanded(
//                                   child: Column(
//                                 children: [
//                                   DropdownMenuExample(
//                                     btnLabel: "From",
//                                   ),
//                                 ],
//                               ))
//                             ],
//                           ),
//                           const TextField(
//                             decoration: InputDecoration(
//                               border: InputBorder.none,
//                               // label: Text("Kiasi"),
//                             ),
//                           ),
//                           const Divider(
//                             color: Color.fromARGB(255, 119, 119, 119),
//                           ),
//                           const SizedBox(height: 12),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: const Color(0xFF6D53F4),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(vertical: 15),
//                                 child: Text(
//                                   'Calculate',
//                                   style: GoogleFonts.inter(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 14),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// const List<String> list = <String>[
//   'M-Pesa',
//   'Airtel Money',
//   'Tigopesa',
//   'Halopesa'
// ];

// class DropdownMenuExample extends StatefulWidget {
//   String btnLabel;

//   DropdownMenuExample({
//     required this.btnLabel,
//   });
//   @override
//   State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
// }

// class _DropdownMenuExampleState extends State<DropdownMenuExample> {
//   String dropdownValue = list.first;

//   @override
//   Widget build(BuildContext context) {
//     return DropdownMenu<String>(
//       menuHeight: 400,
//       inputDecorationTheme:
//           const InputDecorationTheme(isDense: true, border: InputBorder.none),
//       label: Text(widget.btnLabel),
//       initialSelection: list.first,
//       onSelected: (String? value) {
//         setState(() {
//           dropdownValue = value!;
//         });
//       },
//       dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
//         return DropdownMenuEntry<String>(value: value, label: value);
//       }).toList(),
//     );
//   }
// }

// class PaymentOption {
//   final String label;
//   final IconData icon;

//   PaymentOption(this.label, this.icon);
// }

// List<PaymentOption> paymentOptions = <PaymentOption>[
//   PaymentOption('M-Pesa', Icons.phone_android),
//   PaymentOption('Airtel Money', Icons.account_balance_wallet),
//   PaymentOption('Tigopesa', Icons.credit_card),
//   PaymentOption('Halopesa', Icons.monetization_on),
// ];

// class DropdownMenuExample extends StatefulWidget {
//   final String btnLabel;

//   const DropdownMenuExample({super.key, required this.btnLabel});

//   @override
//   State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
// }

// class _DropdownMenuExampleState extends State<DropdownMenuExample> {
//   PaymentOption dropdownValue = paymentOptions.first;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: DropdownMenu<PaymentOption>(
//         // menuHeight: 400,

//         inputDecorationTheme: const InputDecorationTheme(
//           isDense: true,
//           border: InputBorder.none,
//         ),
//         label: Text(widget.btnLabel),
//         initialSelection: paymentOptions.first,
//         onSelected: (PaymentOption? value) {
//           setState(() {
//             dropdownValue = value!;
//           });
//         },
//         dropdownMenuEntries: paymentOptions
//             .map<DropdownMenuEntry<PaymentOption>>((PaymentOption option) {
//           return DropdownMenuEntry<PaymentOption>(
//             value: option,
//             label: option.label, // Keep the label as a string
//             // leadingIcon: Icon(option.icon), // Use the leadingIcon property
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: const Text('DropdownMenu with Icons')),
//       body: const Center(
//         child: DropdownMenuExample(btnLabel: 'Select Payment Method'),
//       ),
//     ),
//   ));
// }
