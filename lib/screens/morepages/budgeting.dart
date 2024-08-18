import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pesatrack/providers/budgets_provider.dart';
import 'package:pesatrack/models/budget.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budgets'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
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
            return Center(child: Text('No budgets available'));
          }

          return ListView.builder(
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return ListTile(
                title: Text('No Description'),
                subtitle: Text('Amount: \$${budget.amount.toStringAsFixed(2)}\n'
                    'From: ${budget.startDate}\n'
                    'To: ${budget.endDate}'),
                onTap: () {
                  showAddEditBudgetModal(context, budget: budget);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showAddEditBudgetModal(BuildContext context, {Budget? budget}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _startDateController = TextEditingController();
    final TextEditingController _endDateController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    bool _isLoading = false;

    final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

    if (budget != null) {
      // Initialize fields for editing
      _amountController.text = budget.amount.toString();
      _startDateController.text = budget.startDate.toString();
      _endDateController.text = budget.endDate.toString();
      // _descriptionController.text = budget.description ?? '';
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
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
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
                                    labelText: 'Description',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
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
                                                      endDate: DateTime.tryParse(
                                                          _dateFormat.format(
                                                              DateTime.parse(
                                                                  _endDateController
                                                                      .text)))!,
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to ${budget != null ? 'update' : 'add'} budget: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } finally {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF6D53F4),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Text(
                                              '${budget != null ? 'Update' : 'Add'} Budget',
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
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
