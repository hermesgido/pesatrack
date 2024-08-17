import 'dart:convert';
import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/services/apiservice.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'dart:developer';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/services/apiservice.dart';
import 'package:provider/provider.dart';

void showAddTransactionModal(BuildContext context) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  Job? _selectedCategory;
  String _selectedType = "Expense";
  bool _isLoading = false;

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
                              const Text(
                                'Add Transaction',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SimpleDropdown(
                                onTypeSelected: (String? selectedType) {
                                  setState(() {
                                    _selectedType = selectedType ?? "Expense";
                                  });
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
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
                                  labelText: _selectedType == "Expense"
                                      ? 'Expense Amount'
                                      : 'Income Amount',
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
                              SearchDropdown(
                                onCategorySelected: (Job? selectedCategory) {
                                  setState(() {
                                    _selectedCategory = selectedCategory;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
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
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    _dateController.text =
                                        "${selectedDate.toLocal()}"
                                            .split(' ')[0];
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select a date';
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
                                            final transactionProvider = Provider
                                                .of<TransactionsProvider>(
                                                    context,
                                                    listen: false);

                                            if (_selectedCategory != null) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              try {
                                                await transactionProvider
                                                    .createTransaction(
                                                  transactionType: _selectedType
                                                      .toLowerCase(),
                                                  name: _nameController.text,
                                                  amount: double.parse(
                                                      _amountController.text),
                                                  date: _dateController.text,
                                                  description:
                                                      _descriptionController
                                                          .text,
                                                  category:
                                                      _selectedCategory!.id,
                                                );
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to add transaction: $e'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } finally {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please select a category'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
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
                                            'Add $_selectedType',
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

  const SearchDropdown({required this.onCategorySelected, Key? key})
      : super(key: key);

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
      excludeSelected: false,
      onChanged: (value) {
        setState(() {});
        widget.onCategorySelected(value);
      },
    );
  }
}
