import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Categories',
                style: textTheme.titleLarge,
              ),
              Text(
                'See All',
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 16),

          Container(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryItem(context, Icons.repeat, "Recurring"),
                _buildCategoryItem(context, Icons.store, "Groceries"),
                _buildCategoryItem(context, Icons.shopping_bag, "Shopping"),
                _buildCategoryItem(context, Icons.devices, "Gadgets"),
                _buildCategoryItem(context, Icons.restaurant, "Food"),
                _buildCategoryItem(context, Icons.local_gas_station, "Fuel"),
                _buildCategoryItem(context, Icons.public, "Online"),
                _buildCategoryItem(
                    context, Icons.account_balance, "NetBanking"),
              ],
            ),
          )
          // Categories Grid
          // ListView(
          //   crossAxisCount: 4,
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   childAspectRatio: 1,
          //   mainAxisSpacing: 16,
          //   crossAxisSpacing: 16,
          //   children: [
          //     _buildCategoryItem(context, Icons.repeat, "Recurring"),
          //     _buildCategoryItem(context, Icons.store, "Groceries"),
          //     _buildCategoryItem(context, Icons.shopping_bag, "Shopping"),
          //     _buildCategoryItem(context, Icons.devices, "Gadgets"),
          //     _buildCategoryItem(context, Icons.restaurant, "Food"),
          //     _buildCategoryItem(context, Icons.local_gas_station, "Fuel"),
          //     _buildCategoryItem(context, Icons.public, "Online"),
          //     _buildCategoryItem(context, Icons.account_balance, "NetBanking"),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, IconData iconData, String label) {
    return Container(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Theme.of(context).canvasColor,
              radius: 24,
              child: Icon(
                iconData,
                color: Theme.of(context).colorScheme.secondary,

                // color: Theme.of(context).primaryColor,
              )),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
