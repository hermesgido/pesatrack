import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pesatrack/models/transaction_summary.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:provider/provider.dart';

class HomeTopCard extends StatefulWidget {
  const HomeTopCard({
    super.key,
    required this.theme,
    required this.textTheme,
  });

  final ThemeData theme;
  final TextTheme textTheme;

  @override
  State<HomeTopCard> createState() => _HomeTopCardState();
}

class _HomeTopCardState extends State<HomeTopCard> {
  String filterOption = "Today";

  final List<String> filterOptions = [
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'This Year'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider =
          Provider.of<TransactionsProvider>(context, listen: false);
      transactionProvider.fetchTransactionsHomePage();
    });
  }

  SummaryData getFilteredSummaryData(TransactionSummary? summary) {
    if (summary == null) {
      return SummaryData(totalIncome: 0, totalExpense: 0, totalBalance: 0);
    }

    switch (filterOption) {
      case "Today":
        return summary.today;
      case "Yesterday":
        return summary.yesterday;
      case "This Week":
        return summary.thisWeek;
      case "This Month":
        return summary.thisMonth;
      case "This Year":
        return summary.thisYear;
      default:
        return summary.today;
    }
  }

  void _filterSummary(String? selectedFilter) {
    setState(() {
      if (selectedFilter != null) {
        filterOption = selectedFilter;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, transactionsProvider, child) {
        final isLoading = transactionsProvider.isLoading;
        final summary = transactionsProvider.transactionSummary;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.theme.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLoading
              ? LoadingWidget()
              : summary == null
                  ? LoadingWidget()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Balance",
                                  style: widget.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Tsh ${getFilteredSummaryData(summary).totalBalance.toStringAsFixed(0)}",
                                  style:
                                      widget.textTheme.headlineMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            DropdownButton<String>(
                              dropdownColor:
                                  widget.theme.colorScheme.background,
                              value: filterOption,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: widget.theme.colorScheme.secondary,
                              ),
                              underline: Container(
                                height: 0,
                              ),
                              onChanged: _filterSummary,
                              items: filterOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: widget.textTheme.bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),

                            // PopupMenuButton<String>(
                            //   icon: const Icon(
                            //     Icons.more_vert_outlined,
                            //     color: Colors.white,
                            //   ),
                            //   onSelected: _filterSummary,
                            //   itemBuilder: (BuildContext context) {
                            //     return [
                            //       'Today',
                            //       'Yesterday',
                            //       'This Week',
                            //       'This Month',
                            //       'This Year'
                            //     ].map((String choice) {
                            //       return PopupMenuItem<String>(
                            //         value: choice,
                            //         child: Text(choice),
                            //       );
                            //     }).toList();
                            //   },
                            // )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward,
                                    color: Colors.green),
                                const SizedBox(width: 5),
                                Text(
                                  "Income",
                                  style: widget.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              "+ Tsh ${getFilteredSummaryData(summary).totalIncome.toStringAsFixed(0)}",
                              style: widget.textTheme.bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward,
                                    color: Colors.red),
                                const SizedBox(width: 5),
                                Text(
                                  "Expense",
                                  style: widget.textTheme.bodyMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            Text(
                              "- Tsh ${getFilteredSummaryData(summary).totalExpense.toStringAsFixed(0)}",
                              style: widget.textTheme.bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Column LoadingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: widget.textTheme.bodyMedium!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "Tsh 000000",
                  style: widget.textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_outlined,
                color: Colors.white,
              ),
              onSelected: _filterSummary,
              itemBuilder: (BuildContext context) {
                return [
                  'Today',
                  'Yesterday',
                  'This Week',
                  'This Month',
                  'This Year'
                ].map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_downward, color: Colors.green),
                const SizedBox(width: 5),
                Text(
                  "Income",
                  style: widget.textTheme.bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            Text(
              "+ Tsh 00000",
              style: widget.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
            Row(
              children: [
                const Icon(Icons.arrow_upward, color: Colors.red),
                const SizedBox(width: 5),
                Text(
                  "Expense",
                  style: widget.textTheme.bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            Text(
              "- Tsh 00000",
              style: widget.textTheme.bodyMedium!.copyWith(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
