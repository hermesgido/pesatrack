import 'package:flutter/material.dart';
import 'package:pesatrack/main.dart';
import 'package:pesatrack/screens/morepages/budgeting.dart';
import 'package:pesatrack/screens/morepages/categories.dart';
import 'package:pesatrack/screens/morepages/transfer_charges.dart';

class MorePages extends StatelessWidget {
  const MorePages({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const MyApp();
                }));
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: const Text("Explore More"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return CategoryPage();
                  }));
                },
                child: const MoreItem(
                  imagePath: "assets/icons/categories.png",
                  name: "Categories",
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BudgetPage();
                  }));
                },
                child: const MoreItem(
                  imagePath: "assets/icons/budget.png",
                  name: "Budgeting",
                ),
              ),
              const MoreItem(
                imagePath: "assets/icons/recuring.png",
                name: "Reccuring Payments",
              ),
              const MoreItem(
                imagePath: "assets/icons/projects.png",
                name: "Projects Finance",
              ),
              const MoreItem(
                imagePath: "assets/icons/invest.png",
                name: "Investments",
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const TransferCharges();
                  }));
                },
                child: const MoreItem(
                  imagePath: "assets/icons/charges.png",
                  name: "Transfer Charges",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoreItem extends StatelessWidget {
  final String imagePath;
  final String name;

  const MoreItem({
    required this.imagePath,
    required this.name,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Image.asset(
                imagePath,
                scale: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(name)
          ],
        ),
      ),
    );
  }
}
