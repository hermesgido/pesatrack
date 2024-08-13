import 'package:flutter/material.dart';

void showAddExpenseModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Transparent background
    isDismissible:
        true, // Allows dismissing the modal by tapping outside or pressing the back button
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop(); // Closes the modal if tapped outside
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add Expense',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Expense Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Choose Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  child: Text("Food"), value: "Food"),
                              DropdownMenuItem(
                                  child: Text("Transport"), value: "Transport"),
                              // Add more categories here
                            ],
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              // Handle the selected date here
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Payment Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                  child: Text("Credit Card"),
                                  value: "Credit Card"),
                              DropdownMenuItem(
                                  child: Text("Cash"), value: "Cash"),
                              // Add more payment types here
                            ],
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Handle save expense action here
                            },
                            child: const Text('Add Expense'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
