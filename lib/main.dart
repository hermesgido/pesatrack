import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesatrack/screens/home_page.dart';
import 'package:pesatrack/screens/settings/settings.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:pesatrack/utils/theme.dart';
import 'package:pesatrack/widgets/bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6D53F4),
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      themeMode: ThemeMode.dark,
      darkTheme: AppThemes.darkTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    if (index == 2) {
      // Show bottom sheet without changing the page
      showAddExpenseModal(context);
    } else {
      _pageController.jumpToPage(index);
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const List<TabItem> items = [
      TabItem(
        icon: Icons.home,
        title: 'Home',
      ),
      TabItem(
        icon: Icons.show_chart,
        title: 'Track',
      ),
      TabItem(
        icon: Icons.add_circle_outline,
        title: '',
      ),
      TabItem(
        icon: Icons.account_balance_wallet,
        title: 'Wallet',
      ),
      TabItem(
        icon: Icons.person,
        title: 'Profile',
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomeScreen(),
          const Center(child: Text('Total Balance Page')),
          HomeScreen(), // Keep the current page active instead of showing an empty page
          const Center(child: Text('Last Transactions Page')),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: BottomBarCreative(
        items: items,
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.grey,
        colorSelected: Colors.white,
        indexSelected: _currentIndex,
        isFloating: true,
        highlightStyle: HighlightStyle(
          color: Theme.of(context).primaryColor,
          isHexagon: true,
          elevation: 2,
        ),
        onTap: (int index) {
          _onNavBarTapped(index);
        },
      ),
    );
  }
}
