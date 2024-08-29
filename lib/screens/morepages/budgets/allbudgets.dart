import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/models/budget.dart';
import 'package:pesatrack/providers/budgets_provider.dart';
import 'package:pesatrack/providers/yearly_budget_provider.dart';
import 'package:pesatrack/services/apiservice.dart';
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
      final budgetProvider =
          Provider.of<YearBudgetSummaryProvider>(context, listen: false);
      budgetProvider.fetchYearSummary(2024);
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = Provider.of<YearBudgetSummaryProvider>(context);

    if (budgetProvider.isLoading) {
      return Scaffold(
        body: Center(child: customLoadingIndicator(context)),
      );
    }

    if (budgetProvider.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${budgetProvider.errorMessage}')),
      );
    }

    final transactionsByDate = budgetProvider.budgetsByDate;
    final hasTransactions = transactionsByDate.isNotEmpty;

    // Format amount
    String totalExpenseFormatted =
        "Tsh ${NumberFormat('#,##0').format(budgetProvider.totalSpent)}";
    String totalIncomFormatted =
        "Tsh ${NumberFormat('#,##0').format(budgetProvider.totolBudgeted)}";

    String totalBalanceFormatted =
        "Tsh ${NumberFormat('#,##0').format(budgetProvider.balance)}";
    DateFormat dateFormat = DateFormat('MMM d, EEE'); // Example: Aug 23, Mon

    // String formattedDate = dateFormat.format(DateTime.parse(time));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showAddEditBudgetModal(context);
            print("object");
          }),
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
                          "Budgetting",
                          style: TextStyle(
                              // color: Theme.of(context).colorScheme.secondary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox()
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.skip_previous_outlined,
                              color: Colors.white),
                          onPressed: () {
                            budgetProvider.previousMonth();
                          },
                        ),
                        const SizedBox(width: 20),
                        Text(
                          budgetProvider.selectedMonth,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.skip_next_outlined,
                              color: Colors.white),
                          onPressed: () {
                            budgetProvider.nextMonth();
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
                            const Text("TOTAL BUDGETED",
                                style: TextStyle(color: Colors.white)),
                            Text(
                              totalIncomFormatted,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
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
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transactionsByDate.entries.map((entry) {
                          final date = entry.key;
                          final transactionGroup = entry.value;
                          String totalBudget =
                              "+ Tsh ${NumberFormat('#,##0').format(transactionGroup.totalBudget)}";

                          String totalSpent =
                              "+ Tsh ${NumberFormat('#,##0').format(transactionGroup.totalSpent)}";

                          DateFormat dateFormat =
                              DateFormat('MMM d, EEE'); // Example: Aug 23, Mon
                          String formattedDate =
                              dateFormat.format(DateTime.parse(date));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(), // Prevents independent scrolling
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 items per row
                                  crossAxisSpacing: 10, // Horizontal spacing
                                  mainAxisSpacing: 10, // Vertical spacing
                                  childAspectRatio: 2.6 /
                                      2, // Adjust the aspect ratio as needed
                                ),
                                itemCount: transactionGroup.budgets.length,
                                itemBuilder: (context, index) {
                                  var budget = transactionGroup.budgets[index];
                                  return _buildBudgetCard(
                                    context,
                                    budget.category?.categoryName ?? "Category",
                                    budget.amount!,
                                    budget.amountSpent.toString(),
                                    budget,
                                  );
                                },
                              ),
                            ],
                          );
                        }).toList(),
                      )
                    : const Center(
                        child: Text(
                          'No budgets for this month',
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

Widget _buildBudgetCard(BuildContext context, String? categoryName,
    String? budgetTotal, String? budgetSpent, Budget? budget) {
  final budgetSpentParsed = double.tryParse(budgetSpent ?? '');
  final budgetTotalParsed = double.tryParse(budgetTotal ?? '');
  String budgetSpentFormatted =
      "Tsh ${NumberFormat('#,##0').format(budgetSpentParsed)}";
  String budgetTotalFormatted =
      "Tsh ${NumberFormat('#,##0').format(budgetTotalParsed)}";
  var progressColor = Colors.red;

  var percent = 0.0;
  var percent100 = 0.0;

  if (budgetSpentParsed != null &&
      budgetTotalParsed != null &&
      budgetTotalParsed != 0) {
    if ((budgetSpentParsed / budgetTotalParsed) > 0.7) {
      progressColor = Colors.red;
    }

    if ((budgetSpentParsed / budgetTotalParsed) > 1) {
      percent = 1;
    } else {
      percent = budgetSpentParsed / budgetTotalParsed;
    }
    percent100 = double.parse((percent * 100).toStringAsFixed(2));

    print('Percentage spent: $percent100%');
  } else {
    percent = 0.0;
    percent100 = 0.0;

    print('Invalid data, cannot calculate percentage.');
  }

  return Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Theme.of(context).canvasColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // const Spacer(),
            Text(categoryName ?? "Category"),
            InkWell(
              onTap: () {},
              child: PopupMenuButton<SampleItem>(
                onSelected: (SampleItem item) {
                  if (item == SampleItem.itemOne) {
                    showAddEditBudgetModal(context, budget: budget);
                  } else if (item == SampleItem.itemTwo) {
                    _showDeleteConfirmationDialog(context, budget!);
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<SampleItem>>[
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemOne,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemTwo,
                    child: Text('Delete'),
                  ),
                  const PopupMenuItem<SampleItem>(
                    value: SampleItem.itemThree,
                    child: Text('Ignore'),
                  ),
                ],
                child: const Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        Row(
          children: [
            const Spacer(),
            CircularPercentIndicator(
              radius: 30.0,
              lineWidth: 5.0,
              percent: percent,
              center: Text("$percent100 %"),
              progressColor: progressColor,
              backgroundColor: Colors.green,
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total "),
                    Text(
                      budgetTotalFormatted,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Spent"),
                    Text(
                      budgetSpentFormatted,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

void _showDeleteConfirmationDialog(BuildContext context, Budget budget) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this budget?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // Perform the delete operation
              // e.g., budgetProvider.deleteBudget(budget);
              Navigator.of(context).pop(); // Close the dialog after deletion
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void onEdit() {}

void showAddEditBudgetModal(BuildContext context, {Budget? budget}) {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _startDateController =
      TextEditingController(text: _dateFormat.format(DateTime.now()));
  final TextEditingController _endDateController =
      TextEditingController(text: _dateFormat.format(DateTime.now()));
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Job? _selectedCategory;
  String _selectedType = "Expense";

  if (budget != null) {
    // Initialize fields for editing
    _amountController.text = budget.amount.toString();
    _startDateController.text = _dateFormat.format(budget.startDate!);
    _endDateController.text = _dateFormat.format(budget.endDate!);
    _descriptionController.text = budget.budgetName ?? '';
    _selectedCategory = Job(
      budget.category!.id.toString(),
      budget.category!.categoryName!,
      Icons.catching_pokemon,
    );
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  budget != null ? 'Edit Budget' : 'Add Budget',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                SearchDropdown(
                                  initialValue: _selectedCategory,
                                  onCategorySelected: (Job? value) {
                                    _selectedCategory = value;
                                    print(value);
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _amountController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    labelText: 'Amount',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an amount';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _startDateController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    labelText: 'Start Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (selectedDate != null) {
                                      _startDateController.text =
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0];
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a start date';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _endDateController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    labelText: 'End Date',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    suffixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (selectedDate != null) {
                                      _endDateController.text =
                                          "${selectedDate.toLocal()}"
                                              .split(' ')[0];
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an end date';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final budgetsProvider =
                                                  Provider.of<BudgetProvider>(
                                                      context,
                                                      listen: false);

                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                if (budget != null) {
                                                  await budgetsProvider
                                                      .updateBudget(
                                                    budget.id!,
                                                    Budget(
                                                      amount: _amountController
                                                          .text,
                                                      startDate:
                                                          DateTime.tryParse(
                                                              _startDateController
                                                                  .text)!,
                                                      endDate:
                                                          DateTime.tryParse(
                                                              _endDateController
                                                                  .text)!,
                                                      budgetName:
                                                          _descriptionController
                                                              .text,
                                                    ),
                                                  );
                                                } else {
                                                  await budgetsProvider
                                                      .createBudget(
                                                    Budget(
                                                      categoryId:
                                                          _selectedCategory?.id,
                                                    amount: _amountController
                                                          .text,
                                                      startDate:
                                                          DateTime.tryParse(
                                                        _dateFormat.format(
                                                          DateTime.parse(
                                                              _startDateController
                                                                  .text),
                                                        ),
                                                      )!,
                                                      endDate:
                                                          DateTime.tryParse(
                                                        _dateFormat.format(
                                                          DateTime.parse(
                                                              _endDateController
                                                                  .text),
                                                        ),
                                                      )!,
                                                      budgetName:
                                                          _descriptionController
                                                              .text,
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                // Handle error
                                              } finally {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            }
                                          },
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            budget != null
                                                ? 'Update Budget'
                                                : 'Add Budget',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ));
    },
  );
}

const List<String> _list = [
  'Expense',
  'Income',
];

class SimpleDropdown extends StatefulWidget {
  final ValueChanged<String?> onTypeSelected;

  const SimpleDropdown({required this.onTypeSelected, super.key});

  @override
  State<SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<SimpleDropdown> {
  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.background,
        closedBorderRadius: BorderRadius.circular(12),
        closedBorder: const Border(
          bottom: BorderSide(color: Colors.white),
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
          right: BorderSide(color: Colors.white),
        ),
        expandedFillColor: Theme.of(context).colorScheme.background,
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Theme.of(context).colorScheme.background,
        ),
      ),
      hintText: 'Select job role',
      items: _list,
      initialItem: _list[0],
      excludeSelected: false,
      onChanged: (value) {
        setState(() {});
        widget.onTypeSelected(value);
        log('changing value to: $value');
      },
    );
  }
}

class Job with CustomDropdownListFilter {
  final String id;
  final String name;
  final IconData icon;

  const Job(this.id, this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool filter(String query) {
    return name.toLowerCase().contains(query.toLowerCase());
  }
}

class SearchDropdown extends StatefulWidget {
  final ValueChanged<Job?> onCategorySelected;
  final Job? initialValue;

  const SearchDropdown({
    required this.onCategorySelected,
    Key? key,
    this.initialValue,
  }) : super(key: key);

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  List<Job> _list = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await ApiService().getCategories();
      if (response.statusCode == 200) {
        List<dynamic> categoriesJson = jsonDecode(response.body);
        setState(() {
          _list = categoriesJson
              .map((category) => Job(category['id'].toString(),
                  category['category_name'], Icons.category))
              .toList();
          _loading = false;
        });
        _list.add(const Job("0", "Select", Icons.category));
      } else {
        log('Failed to load categories');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // return Center(child: customLoadingIndicator(context));
    }
    print(widget.initialValue);
    print("this is initial value");

    return CustomDropdown<Job>.search(
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.background,
        closedBorderRadius: BorderRadius.circular(12),
        closedBorder: const Border(
          bottom: BorderSide(color: Colors.white),
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
          right: BorderSide(color: Colors.white),
        ),
        expandedFillColor: Theme.of(context).colorScheme.background,
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Theme.of(context).colorScheme.background,
        ),
      ),
      hintText: 'Select Category',
      items: _list,
      // initialItem: widget.initialValue ?? Job("0", "Select", Icons.category),
      excludeSelected: false,
      onChanged: (value) {
        setState(() {});
        widget.onCategorySelected(value);
      },
    );
  }
}

enum SampleItem { itemOne, itemTwo, itemThree }
