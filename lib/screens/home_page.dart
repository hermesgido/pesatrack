import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pesatrack/screens/settings/settings.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            // Header
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/avator.png'),
                  radius: 23,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning!",
                      style: textTheme.bodyMedium!.copyWith(color: Colors.grey),
                    ),
                    Text(
                      "Kathir",
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.notification_add_outlined,
                  size: 28,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Total Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Balance",
                    style: textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Tsh 39,455",
                    style: textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.arrow_downward, color: Colors.green),
                          const SizedBox(width: 5),
                          Text(
                            "Income",
                            style: textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        "+ Tsh 154",
                        style:
                            textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward, color: Colors.red),
                          const SizedBox(width: 5),
                          Text(
                            "Expense",
                            style: textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Text(
                        "- Tsh 300",
                        style:
                            textTheme.bodyMedium!.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CategoriesWidget(),
            const SizedBox(height: 30),
            // Last Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Last Transaction",
                  style: textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "See all",
                  style:
                      textTheme.bodyMedium!.copyWith(color: theme.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTransactionCard(
              context,
              time: "5:31 PM",
              title: "Zudio T.Nagar Store",
              subtitle: "Clothing",
              amount: "Tsh 4,879",
              color: Colors.purple.shade50,
            ),
            _buildTransactionCard(
              context,
              time: "10:59 AM",
              title: "Zudio T.Nagar Store",
              subtitle: "Clothing",
              amount: "Tsh 105,000",
              color: Colors.green.shade50,
            ),
            _buildTransactionCard(
              context,
              time: "Yesterday, 1:26 PM",
              title: "MC Donalds",
              subtitle: "Food",
              amount: "Tsh 4,879",
              color: Colors.teal.shade50,
            ),
            _buildTransactionCard(
              context,
              time: "25-Jun, 12:30 PM",
              title: "Apollo Medicals",
              subtitle: "Health",
              amount: "Tsh 2,102",
              color: Colors.pink.shade50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context,
      {required String time,
      required String title,
      required String subtitle,
      required String amount,
      required Color color}) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(subtitle),
              const SizedBox(height: 5),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: textTheme.bodyMedium),
              Text(
                amount,
                style: textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
          const SizedBox(height: 16),
          // Categories Grid
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildCategoryItem(context, Icons.repeat, "Recurring"),
              _buildCategoryItem(context, Icons.store, "Groceries"),
              _buildCategoryItem(context, Icons.shopping_bag, "Shopping"),
              _buildCategoryItem(context, Icons.devices, "Gadgets"),
              _buildCategoryItem(context, Icons.restaurant, "Food"),
              _buildCategoryItem(context, Icons.local_gas_station, "Fuel"),
              _buildCategoryItem(context, Icons.public, "Online"),
              _buildCategoryItem(context, Icons.account_balance, "NetBanking"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, IconData iconData, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundColor: Theme.of(context).cardColor,
            radius: 24,
            child: Icon(
              iconData,
              color: Colors.white,
            )),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
