import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferCharges extends StatelessWidget {
  const TransferCharges({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Transactions Fees"),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios_new),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Text("Kiasi"),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          DropdownMenuExample(
                            btnLabel: "From",
                          ),
                        ],
                      ))
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 119, 119, 119),
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Text("Garama"),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          DropdownMenuExample(
                            btnLabel: 'To',
                          )
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D53F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Calculate',
                          style: GoogleFonts.inter(
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
            const SizedBox(height: 28),
            const Text(
              "Withdaw Fees",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                label: Text("Kiasi"),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          DropdownMenuExample(
                            btnLabel: "From",
                          ),
                        ],
                      ))
                    ],
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      // label: Text("Kiasi"),
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 119, 119, 119),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D53F4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Calculate',
                          style: GoogleFonts.inter(
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
    ));
  }
}

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

class PaymentOption {
  final String label;
  final IconData icon;

  PaymentOption(this.label, this.icon);
}

List<PaymentOption> paymentOptions = <PaymentOption>[
  PaymentOption('M-Pesa', Icons.phone_android),
  PaymentOption('Airtel Money', Icons.account_balance_wallet),
  PaymentOption('Tigopesa', Icons.credit_card),
  PaymentOption('Halopesa', Icons.monetization_on),
];

class DropdownMenuExample extends StatefulWidget {
  final String btnLabel;

  const DropdownMenuExample({super.key, required this.btnLabel});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  PaymentOption dropdownValue = paymentOptions.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<PaymentOption>(
      menuHeight: 400,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        border: InputBorder.none,
      ),
      label: Text(widget.btnLabel),
      initialSelection: paymentOptions.first,
      onSelected: (PaymentOption? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: paymentOptions
          .map<DropdownMenuEntry<PaymentOption>>((PaymentOption option) {
        return DropdownMenuEntry<PaymentOption>(
          value: option,
          label: option.label, // Keep the label as a string
          leadingIcon: Icon(option.icon), // Use the leadingIcon property
        );
      }).toList(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('DropdownMenu with Icons')),
      body: const Center(
        child: DropdownMenuExample(btnLabel: 'Select Payment Method'),
      ),
    ),
  ));
}
