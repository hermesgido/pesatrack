import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesatrack/providers/authprovider.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/screens/auth/login.dart';
import 'package:pesatrack/screens/home_page.dart';
import 'package:pesatrack/screens/settings/profile_screen.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:pesatrack/utils/theme.dart';
import 'package:pesatrack/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionsProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check if the user is authenticated
    Provider.of<AuthProvider>(context, listen: false)
        .checkAuthentication(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF6D53F4),
      statusBarIconBrightness: Brightness.light,
    ));

    final authProvider = Provider.of<AuthProvider>(context);
    final trans = Provider.of<TransactionsProvider>(context);

    if (authProvider.isLoading) {
      trans.fetchTransactions();
      trans.fetchTransactionsHomePage();
      // Show loading screen while authentication check is in progress
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      themeMode: ThemeMode.dark,
      darkTheme: AppThemes.darkTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // If authenticated, show MainPage, else show LoginPage
      home: authProvider.isAuthenticated ? const MainPage() : const LoginPage(),
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

  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Check if the user is authenticated
    if (!authProvider.isAuthenticated) {
      // Redirect to LoginPage if not authenticated
      Future.microtask(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onNavBarTapped(int index) {
    if (index == 2) {
      showAddTransactionModal(context);
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut, 
      );
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
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          HomeScreen(),
          const Center(child: Text('Total Balance Page')),
          HomeScreen(), // Keep the current page active instead of showing an empty page
          const Center(child: Text('Last Transactions Page')),
          ProfileScreen()
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
          color: Theme.of(context).colorScheme.secondary,
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

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Center(
        child: customLoadingIndicator(context),
      ),
    );
  }
}
