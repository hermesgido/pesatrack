import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/models/category.dart';
import 'package:pesatrack/providers/year_summary_provider.dart';
import 'package:pesatrack/utils/capitalize.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pesatrack/models/transaction.dart';
import 'package:pesatrack/screens/transactions/edit_transaction.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider =
          Provider.of<YearSummaryProvider>(context, listen: false);
      transactionProvider.fetchYearSummary(2024);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<YearSummaryProvider>(context);

    if (transactionProvider.isLoading) {
      return Scaffold(
        body: Center(child: customLoadingIndicator(context)),
      );
    }

    if (transactionProvider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${transactionProvider.errorMessage}')),
      );
    }

    final transactionsByDate = transactionProvider.transactionsByDate;
    final hasTransactions = transactionsByDate.isNotEmpty;

    // Format amount
    String totalExpenseFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.totalExpenses)}";
    String totalIncomFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.totalIncome)}";

    String totalBalanceFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.balance)}";
    DateFormat dateFormat = DateFormat('MMM d, EEE'); // Example: Aug 23, Mon

    // String formattedDate = dateFormat.format(DateTime.parse(time));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Month navigation and summary
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        const Text(
                          "Expense & Income",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous_outlined,
                              color: Colors.white),
                          onPressed: () {
                            transactionProvider.previousMonth();
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          transactionProvider.selectedMonth,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.skip_next_outlined,
                              color: Colors.white),
                          onPressed: () {
                            transactionProvider.nextMonth();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Summary of expenses, income, and total balance
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("EXPENSES",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalExpenseFormatted,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("INCOME",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalIncomFormatted,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("TOTAL",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalBalanceFormatted,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Transaction list
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: hasTransactions
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transactionsByDate.entries.map((entry) {
                          final date = entry.key;
                          final transactionGroup = entry.value;
                          String totalIncome =
                              "+ Tsh ${NumberFormat('#,##0').format(transactionGroup.totalIncome)}";

                          String totalExpense =
                              "+ Tsh ${NumberFormat('#,##0').format(transactionGroup.totalExpenses)}";

                          DateFormat dateFormat =
                              DateFormat('MMM d, EEE'); // Example: Aug 23, Mon

                          String formattedDate =
                              dateFormat.format(DateTime.parse(date));

                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("$formattedDate "),
                                  Row(
                                    children: [
                                      const Icon(Icons.arrow_upward_outlined,
                                          color: Colors.green),
                                      Text(" $totalIncome Tsh"),
                                      const Icon(Icons.arrow_downward_outlined,
                                          color: Colors.red),
                                      Text(" $totalExpense Tsh"),
                                    ],
                                  ),
                                ],
                              ),
                              ...transactionGroup.transactions
                                  .map<Widget>((transaction) {
                                return _buildTransactionCard(
                                  context,
                                  time: transaction.transactionDate,
                                  title: transaction.description,
                                  subtitle: transaction.category,
                                  amount: transaction.amount,
                                  color: transaction.transactionType == "income"
                                      ? Colors.green
                                      : Colors.red,
                                  transaction: Transaction(
                                    id: transaction.id,
                                    amount: transaction.amount,
                                    description: transaction.description,
                                    transactionDate: DateTime.now(),
                                    category: Category(),
                                    transactionType:
                                        transaction.transactionType,
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: Text(
                          'No transactions for this month',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context, {
    required String time,
    required String title,
    required String subtitle,
    required String amount,
    required Color color,
    required Transaction transaction,
  }) {
    final textTheme = Theme.of(context).textTheme;

    double amount2 = double.tryParse(amount) ?? 0.0;

    // Format amount
    String amountFormatted = "Tsh ${NumberFormat('#,##0').format(amount2)}";

    DateFormat dateFormat = DateFormat('MMM d, EEE'); // Example: Aug 23, Mon

    String formattedDate = dateFormat.format(DateTime.parse(time));
    final textFormatter = StringModification();

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EditTransactionScreen(transaction: transaction);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(50)),
              child: const Icon(Icons.monetization_on,
                  size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textFormatter.capitalizeFirstLetter(title),
                  style: textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 5),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(time, style: textTheme.bodyMedium),
                Text(
                  amountFormatted,
                  style: textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
