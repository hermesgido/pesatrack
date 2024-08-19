import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:pesatrack/providers/budgets_provider.dart';
import 'package:pesatrack/models/budget.dart';

class BudgetPage extends StatefulWidget {
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final budgetProvider =
          Provider.of<BudgetProvider>(context, listen: false);
      budgetProvider.fetchBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showAddEditBudgetModal(context);
            },
          ),
        ],
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetsProvider, child) {
          final budgets = budgetsProvider.budgets;

          if (budgets.isEmpty) {
            return const Center(child: Text('No budgets available'));
          }

          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              const spentAmount = 0.0; // Replace with real spent amount
              final remainingAmount = budget.amount - spentAmount;
              final progress =
                  budget.amount > 0 ? spentAmount / budget.amount : 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.budgetName ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Limit: Tsh ${budget.amount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Spent: Tsh ${spentAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Remaining: Tsh ${remainingAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showAddEditBudgetModal(BuildContext context, {Budget? budget}) {
    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _startDateController =
        TextEditingController(text: _dateFormat.format(DateTime.now()));
    final TextEditingController _endDateController =
        TextEditingController(text: _dateFormat.format(DateTime.now()));
    final TextEditingController _descriptionController =
        TextEditingController();
    bool _isLoading = false;

    if (budget != null) {
      // Initialize fields for editing
      _amountController.text = budget.amount.toString();
      _startDateController.text = _dateFormat.format(budget.startDate!);
      _endDateController.text = _dateFormat.format(budget.endDate!);
      _descriptionController.text = budget.budgetName ?? '';
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
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                                    budget != null
                                        ? 'Edit Budget'
                                        : 'Add Budget',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                      labelText: 'Budget Name',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                                    // Edit existing budget
                                                    // await budgetsProvider.updateBudget(
                                                    //   budget.id,
                                                    //   _descriptionController.text,
                                                    //   double.parse(_amountController.text),
                                                    //   DateTime.parse(_startDateController.text),
                                                    //   DateTime.parse(_endDateController.text),
                                                    // );

                                                    await budgetsProvider
                                                        .updateBudget(
                                                      budget.id!,
                                                      Budget(
                                                        amount: double.parse(
                                                            _amountController
                                                                .text),
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
                                                        amount: double.parse(
                                                            _amountController
                                                                .text),
                                                        startDate: DateTime.tryParse(
                                                            _dateFormat.format(
                                                                DateTime.parse(
                                                                    _startDateController
                                                                        .text)))!,
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
                                                    // Add new budget
                                                    // await budgetsProvider.createBudget(
                                                    //   _descriptionController.text,
                                                    //   double.parse(_amountController.text),
                                                    //   DateTime.parse(_startDateController.text),
                                                    //   DateTime.parse(_endDateController.text),
                                                    // );
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
                                          : Text(budget != null
                                              ? 'Update Budget'
                                              : 'Add Budget'),
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
}
