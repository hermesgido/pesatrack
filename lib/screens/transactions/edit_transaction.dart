import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/models/transaction.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/services/apiservice.dart';
import 'package:provider/provider.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  EditTransactionScreen({required this.transaction});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  Job? _selectedCategory;

  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    _amountController = TextEditingController(text: widget.transaction.amount);
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _dateController = TextEditingController(
        text:
            dateFormat.format(widget.transaction.transactionDate!).toString());
    _selectedCategory = Job(widget.transaction.category!.id.toString(),
        widget.transaction.category!.categoryName ?? "Hee", Icons.category);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _deleteTransaction() async {
    final shouldDelete = await PanaraConfirmDialog.showAnimatedGrow(
      context,
      margin: const EdgeInsets.all(20),
      message: "Are you sure you want to delete this transaction?",
      confirmButtonText: "Confirm",
      cancelButtonText: "Cancel",
      onTapCancel: () {
        Navigator.of(context).pop(false);
      },
      onTapConfirm: () {
        Navigator.of(context).pop(true);
      },
      panaraDialogType: PanaraDialogType.error,
    );

    // Future<void> _deleteTransaction() async {
    //   final shouldDelete = await showDialog<bool>(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Delete Transaction'),
    //       content:
    //           const Text('Are you sure you want to delete this transaction?'),
    //       actions: [
    //         TextButton(
    //           child: const Text('Cancel'),
    //           onPressed: () => Navigator.of(context).pop(false),
    //         ),
    //         TextButton(
    //           child: const Text('Delete'),
    //           onPressed: () => Navigator.of(context).pop(true),
    //         ),
    //       ],
    //     ),
    //   );

    if (shouldDelete == true) {
      try {
        final response =
            Provider.of<TransactionsProvider>(context, listen: false);
        response.deleteTransaction(widget.transaction.id!);
        Navigator.pop(context);
      } catch (e) {
        log('Error deleting transaction: $e');
        // Optionally show a Snackbar or another type of alert to notify the user of the error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction'), actions: [
        GestureDetector(
          onTap: _deleteTransaction, // Call the delete method

          child: Container(
            padding: EdgeInsets.only(right: 10),
            child: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Expense Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SearchDropdown(
                initialValue: _selectedCategory,
                onCategorySelected: (Job? selectedCategory) {
                  _selectedCategory = selectedCategory;
                  log('Selected category: ${_selectedCategory?.name} (ID: ${_selectedCategory?.id})');
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(_dateController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    _dateController.text =
                        "${selectedDate.toLocal()}".split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    print(_selectedCategory!.id);
                    if (_amountController.text.isNotEmpty &&
                        _dateController.text.isNotEmpty &&
                        _selectedCategory != null) {
                      final transactionProvider =
                          Provider.of<TransactionsProvider>(context,
                              listen: false);

                      try {
                        await transactionProvider.updateTransaction(
                          id: widget.transaction.id!,
                          amount: double.parse(_amountController.text),
                          date: _dateController.text,
                          description: _descriptionController.text,
                          category: _selectedCategory!.id,
                        );
                        Navigator.of(context).pop();
                      } catch (e) {
                        log('Failed to add expense: $e');
                      }
                    } else {
                      log('Please fill all required fields');
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
                    child: Text(
                      'Save Expense',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
  Job? initialValue;

  SearchDropdown(
      {required this.onCategorySelected, Key? key, this.initialValue})
      : super(key: key);

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  List<Job> _list = [];
  bool _loading = true;
  Job? _initialItem;

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

          // Set the initialItem only if it matches one of the items in the list
          _initialItem = _list.firstWhere(
            (job) => job.id == widget.initialValue?.id,
          );
          _loading = false;
        });
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
      return Center(child: CircularProgressIndicator());
    }

    return CustomDropdown<Job>.search(
      decoration: CustomDropdownDecoration(
        closedFillColor: Theme.of(context).colorScheme.background,
        closedBorderRadius: BorderRadius.circular(12),
        searchFieldDecoration: SearchFieldDecoration(
            fillColor: Theme.of(context).colorScheme.background),
        closedBorder: const Border(
          bottom: BorderSide(color: Colors.white),
          top: BorderSide(color: Colors.white),
          left: BorderSide(color: Colors.white),
          right: BorderSide(color: Colors.white),
        ),
        expandedFillColor: Theme.of(context).colorScheme.background,
      ),
      hintText: 'Select Category',
      items: _list,
      initialItem: _initialItem, // Set the initial selected value if it's valid
      onChanged: (value) {
        setState(() {
          _initialItem = value;
        });
        widget.onCategorySelected(value);
      },
    );
  }
}
