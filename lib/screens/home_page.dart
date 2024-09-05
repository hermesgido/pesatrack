import 'package:flutter/material.dart';
import 'package:pesatrack/models/transaction.dart';
import 'package:pesatrack/providers/year_summary_provider.dart';
import 'package:pesatrack/screens/transactions/all_transactions.dart';
import 'package:pesatrack/screens/transactions/edit_transaction.dart';
import 'package:pesatrack/utils/capitalize.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:pesatrack/providers/transactions_provider.dart'; // Import TransactionsProvider
import 'package:pesatrack/widgets/homepage/home_widgets.dart';
import 'package:pesatrack/widgets/homepage/top_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<TransactionsProvider>(context, listen: false);
      provider.fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("eeeeeeeeeeeeeeeeeeeeeeeeee");

    // if (!provider.isLoading && provider.transactions.isEmpty) {}
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
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
                        style:
                            textTheme.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                      Text(
                        "Welcome",
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
              HomeTopCard(theme: theme, textTheme: textTheme),
              const SizedBox(height: 10),
              CategoriesWidget(),
              // const SizedBox(height: 30),
              // Last Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Last Transactions",
                    style: textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return AllTransactions();
                      }));
                    },
                    child: Text(
                      "See all",
                      style: textTheme.bodyMedium!
                          .copyWith(color: theme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Transactions List
              Expanded(
                child: Consumer<TransactionsProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return customLoadingIndicator(context);
                    }

                    if (provider.transactions.isEmpty) {
                      return const Center(
                          child: Text("No transactions available"));
                    }

                    return ListView.builder(
                      itemCount: provider.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = provider.transactions[index];

                        // DateFormat dateFormat = DateFormat(
                        //     'yyyy-MM-dd'); // Change the format as needed

                        // String formattedDate = transaction.transactionDate !=
                        //         null
                        //     ? dateFormat.format(transaction.transactionDate!)
                        //     : 'Date not available';

                        NumberFormat currencyFormat =
                            NumberFormat('#,###', 'en_US');
                        final textFormatter = StringModification();

                        double amount =
                            double.tryParse(transaction.amount ?? '0') ?? 0.0;
                        String formattedAmount = currencyFormat.format(amount);

                        DateFormat dateFormat =
                            DateFormat('MMM d, EEE'); // Example: Aug 23, Mon

                        String formattedDate = transaction.transactionDate !=
                                null
                            ? dateFormat.format(transaction.transactionDate!)
                            : 'Date not available';
                        return _buildTransactionCard(
                          context,
                          time: formattedDate,
                          title: textFormatter.capitalizeFirstLetter(
                              transaction.description ?? "Name"),
                          subtitle:
                              transaction.category?.categoryName ?? "Category",
                          amount: "Tsh $formattedAmount",
                          color: Colors.grey.shade50,
                          transaction:
                              transaction, // Pass the transaction object here
                        );
                      },
                    );

                    // ListView.builder(
                    //   // reverse: true,
                    //   itemCount: provider.transactions.length,
                    //   itemBuilder: (context, index) {
                    //     final transaction = provider.transactions[index];

                    //     DateFormat dateFormat = DateFormat(
                    //         'yyyy-MM-dd'); // Change the format as needed

                    //     String formattedDate = transaction.transactionDate !=
                    //             null
                    //         ? dateFormat.format(transaction.transactionDate!)
                    //         : 'Date not available';

                    //     NumberFormat currencyFormat =
                    //         NumberFormat('#,###', 'en_US');
                    //     final textFormatter = StringModification();

                    //     double amount =
                    //         double.tryParse(transaction.amount ?? '0') ?? 0.0;

                    //     String formattedAmount = currencyFormat.format(amount);

                    //     return _buildTransactionCard(
                    //       context,

                    //       time: formattedDate,

                    //       title: textFormatter.capitalizeFirstLetter(
                    //           transaction.description ?? "Name"),
                    //       subtitle:
                    //           transaction.category?.categoryName ?? "Category",
                    //       amount: "Tsh $formattedAmount",
                    //       color:
                    //           Colors.grey.shade50, // You can customize colors
                    //     );
                    //   },
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context,
      {required String time,
      required String title,
      required String subtitle,
      required String amount,
      required Color color,
      required Transaction transaction}) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return EditTransactionScreen(
            transaction: transaction,
          );
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(Icons.monetization_on,
                  size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey),
                ),
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
      ),
    );
  }
}
