import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackTransactionsPage extends StatefulWidget {
  @override
  _TrackTransactionsPageState createState() => _TrackTransactionsPageState();
}

class _TrackTransactionsPageState extends State<TrackTransactionsPage> {
  bool _showExpenses = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Transactions'),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Expense and Income Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.8, // Adjusts the height/width ratio
              shrinkWrap:
                  true, // Allows the GridView to take only as much space as needed
              physics:
                  const NeverScrollableScrollPhysics(), // Prevents scrolling within the GridView
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_downward_rounded,
                                color: Colors.red,
                                size: 17,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Text("Expenses"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Today"),
                              Text("Tzs 34,000,000"),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Yesterday"),
                              Text("Tzs 34,000,000"),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("This Month"),
                              Text("Tzs 50,000,000"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_upward_rounded,
                                color: Colors.green,
                                size: 17,
                              ),
                            ),
                          ),
                          const SizedBox(width: 7),
                          const Text("Income"),
                        ],
                      ),
                      const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Today"),
                              Text("Tzs 45,000,000"),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Yesterday"),
                              Text("Tzs 50,000,000"),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("This Month"),
                              Text("Tzs 50,000,000"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Add spacing between GridView and switcher

            // Switcher for chart type
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  isSelected: [_showExpenses, !_showExpenses],
                  onPressed: (index) {
                    setState(() {
                      _showExpenses = index == 0;
                    });
                  },
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Expenses by Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _showExpenses
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.black54,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Income by Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: !_showExpenses
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
                height: 20), // Add spacing between switcher and pie chart

            // Pie chart based on the selected type
            SizedBox(
              height: 300, // Adjust height to fit within the available space
              child: _showExpenses
                  ? ExpensePieChart(
                      expensesByCategory: const {
                        'Food': 15000,
                        'Transport': 8000,
                        'Entertainment': 5000,
                        'Bills': 12000,
                        'Shopping': 7000,
                      },
                    )
                  : IncomePieChart(
                      incomesByCategory: const {
                        'Salary': 30000,
                        'Investments': 15000,
                        'Freelancing': 8000,
                        'Other': 5000,
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> expensesByCategory;

  ExpensePieChart({required this.expensesByCategory});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Expenses by Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildLegend(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return expensesByCategory.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;

      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: amount,
        title:
            '${amount.toStringAsFixed(0)}\n(${(amount / _totalExpenses() * 100).toStringAsFixed(1)}%)',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  double _totalExpenses() {
    return expensesByCategory.values.fold(0, (sum, item) => sum + item);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Transport':
        return Colors.green;
      case 'Entertainment':
        return Colors.orange;
      case 'Bills':
        return Colors.red;
      case 'Shopping':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: expensesByCategory.keys.map((category) {
        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: _getCategoryColor(category),
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class IncomePieChart extends StatelessWidget {
  final Map<String, double> incomesByCategory;

  IncomePieChart({required this.incomesByCategory});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Income by Category",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 4,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _buildLegend(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return incomesByCategory.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;

      return PieChartSectionData(
        color: _getCategoryColor(category),
        value: amount,
        title:
            '${amount.toStringAsFixed(0)}\n(${(amount / _totalIncome() * 100).toStringAsFixed(1)}%)',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  double _totalIncome() {
    return incomesByCategory.values.fold(0, (sum, item) => sum + item);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Salary':
        return Colors.green;
      case 'Investments':
        return Colors.blue;
      case 'Freelancing':
        return Colors.orange;
      case 'Other':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: incomesByCategory.keys.map((category) {
        return Row(
          children: [
            Container(
              width: 12,
              height: 12,
              color: _getCategoryColor(category),
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      }).toList(),
    );
  }
}
