import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pesatrack/models/ExpenseCategory.dart';
import 'package:pesatrack/providers/expense_cat_provider.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';

class ExpenseCategoriesDashboard extends StatelessWidget {
  // Create a map to store fixed colors for each category
  final Map<String, Color> categoryColors = {};

  ExpenseCategoriesDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense By Categories'),
        centerTitle: true,
      ),
      body: Consumer<ExpenseCategoryProvider>(
        builder: (context, provider, child) {
          if (provider.categories.isEmpty) {
            provider.fetchExpenseCategories();
            return Center(child: customLoadingIndicator(context));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Donut chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 230, // Set a specific width
                        child: PieChart(
                          PieChartData(
                            sections: _getSections(provider.categories),
                            centerSpaceRadius: 40,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                          ),
                        ),
                      ),
                      // Custom Legends
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildLegends(provider.categories),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // List of expenses by category
                  ...provider.categories.map((category) {
                    final icon = _getRandomIcon();
                    final color = _getCategoryColor(
                        category.categoryName); // Use consistent color
                    return ExpenseCategoryTile(
                      icon: icon,
                      color: color,
                      category: category.categoryName,
                      amount: category.totalSpent,
                      percentage: category.percentage,
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to generate pie chart sections
  List<PieChartSectionData> _getSections(List<ExpenseCategory> categories) {
    return categories.map((category) {
      final color =
          _getCategoryColor(category.categoryName); // Use consistent color
      return PieChartSectionData(
        color: color,
        value: category.percentage,
        title: '${category.percentage.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }).toList();
  }

  // Method to build custom legends
  List<Widget> _buildLegends(List<ExpenseCategory> categories) {
    return categories.map((category) {
      final color =
          _getCategoryColor(category.categoryName); // Use consistent color
      return _buildLegend(category.categoryName, category.percentage, color);
    }).toList();
  }

  // Method to build a single legend
  Widget _buildLegend(String category, double percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 6,
            backgroundColor: color,
          ),
          const SizedBox(width: 8),
          Text(
            '$category (${percentage.toStringAsFixed(0)}%)', // Category with percentage
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Method to get a consistent color for each category
  Color _getCategoryColor(String categoryName) {
    // If the category already has a color, return it
    if (categoryColors.containsKey(categoryName)) {
      return categoryColors[categoryName]!;
    }

    // Otherwise, generate a new color and store it in the map
    final color = _generateRandomColor();
    categoryColors[categoryName] = color;
    return color;
  }

  // Method to generate random color
  Color _generateRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  // Method to get a random icon
  IconData _getRandomIcon() {
    final icons = [
      Icons.category,
      Icons.trending_up,
      Icons.receipt,
      Icons.sports_soccer,
      Icons.school,
      Icons.local_mall,
      Icons.home,
      Icons.star,
      Icons.fastfood,
      Icons.travel_explore,
    ];
    final random = Random();
    return icons[random.nextInt(icons.length)];
  }
}

// Widget for individual expense category rows
class ExpenseCategoryTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String category;
  final double amount;
  final double percentage;

  const ExpenseCategoryTile({
    super.key,
    required this.icon,
    required this.color,
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    String amountP = "Tsh ${NumberFormat('#,##0').format(amount)}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.3),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Text(
                category,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                amountP,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
