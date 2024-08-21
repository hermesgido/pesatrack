import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/providers/yearly_budget_provider.dart';
import 'package:pesatrack/utils/capitalize.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pesatrack/models/transaction.dart';
import 'package:pesatrack/screens/transactions/edit_transaction.dart';

class AllBudgets extends StatefulWidget {
  const AllBudgets({super.key});

  @override
  State<AllBudgets> createState() => _AllBudgetsState();
}

class _AllBudgetsState extends State<AllBudgets> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider =
          Provider.of<YearBudgetSummaryProvider>(context, listen: false);
      transactionProvider.fetchYearBudgetSummary(2024);
      print(transactionProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<YearBudgetSummaryProvider>(context);

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
    final hasTransactions = transactionsByDate!.isEmpty;

    // Format amount
    String totalSpentFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.totalBudgeted)}";
    String totalBudgetFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.totalSpent)}";

    String totalBalanceFormatted =
        "Tsh ${NumberFormat('#,##0').format(transactionProvider.totalSpent)}";
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
                            child: const Icon(Icons.arrow_back)),
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
                            const Text("TOTAL SPENT",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalSpentFormatted,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("TOTAL BUDGET",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalBudgetFormatted,
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: hasTransactions
                    ? ListView.builder(
                        itemCount:
                            transactionsByDate.length, // Number of Budget items
                        itemBuilder: (context, index) {
                          final budget = transactionsByDate[index];

                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: Text(budget.amount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(DateFormat('MMM d, y')
                                  .format(budget.endDate)),
                              trailing: Text(
                                  "Tsh ${NumberFormat('#,##0').format(budget.amount)}"),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No budgets available',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
              )
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
