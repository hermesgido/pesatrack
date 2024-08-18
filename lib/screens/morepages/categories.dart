import 'package:flutter/material.dart';
import 'package:pesatrack/models/category.dart';
import 'package:pesatrack/providers/categories_provider.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedCategoryType = 'Expense'; // Default category type

  void _showCategoryForm(BuildContext context, {Category? category}) {
    final isEditing = category != null;
    if (isEditing) {
      _nameController.text = category.categoryName!;
      _selectedCategoryType = category.categoryType ?? 'Expense';
    } else {
      _nameController.clear();
      _selectedCategoryType = 'Expense';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (BuildContext context, ScrollController scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 16,
                    right: 16,
                    top: 24,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Category' : 'Add Category',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryType,
                          items: ['Income', 'Expense']
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryType = value!;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Category Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Category Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isEditing) {
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .updateCategory(
                                  category!.id!,
                                  _nameController.text,
                                  _selectedCategoryType.toLowerCase(),
                                );
                              } else {
                                Provider.of<CategoryProvider>(context,
                                        listen: false)
                                    .addCategory(
                                  _nameController.text,
                                  _selectedCategoryType.toLowerCase(),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              isEditing ? 'Update Category' : 'Add Category',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      categoryProvider.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Consumer<CategoryProvider>(
        builder: (ctx, categoryProvider, child) {
          if (categoryProvider.isLoading) {
            return Center(child: customLoadingIndicator(context));
          }

          final incomeCategories = categoryProvider.categories
              .where((category) => category.categoryType == 'income')
              .toList();
          final expenseCategories = categoryProvider.categories
              .where((category) => category.categoryType == 'expense')
              .toList();

          return ListView(
            children: [
              _buildCategoryGroup('Income', incomeCategories),
              _buildCategoryGroup('Expense', expenseCategories),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _showCategoryForm(context),
      ),
    );
  }

  Widget _buildCategoryGroup(String title, List<Category> categories) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        backgroundColor: Colors.transparent,
        collapsedBackgroundColor: Colors.transparent,
        initiallyExpanded: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        children: categories.map((category) {
          return ListTile(
            title: Text(category.categoryName!),
            leading: const Icon(Icons.category),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showCategoryForm(context, category: category),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    Provider.of<CategoryProvider>(context, listen: false)
                        .deleteCategory(category.id!);
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
