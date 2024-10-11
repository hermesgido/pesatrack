import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesatrack/providers/authprovider.dart' as authp;
import 'package:pesatrack/providers/budgets_provider.dart';
import 'package:pesatrack/providers/categories_provider.dart';
import 'package:pesatrack/providers/expense_cat_provider.dart';
import 'package:pesatrack/providers/fee_Provider.dart';
import 'package:pesatrack/providers/forex_provider.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/providers/year_summary_provider.dart';
import 'package:pesatrack/providers/yearly_budget_provider.dart';
import 'package:pesatrack/screens/auth/register.dart';
import 'package:pesatrack/screens/home_page.dart';
import 'package:pesatrack/screens/morepages/more_pages.dart';
import 'package:pesatrack/screens/settings/profile_screen.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:pesatrack/screens/transactions/all_transactions.dart';
import 'package:pesatrack/utils/loading_indicator.dart';
import 'package:pesatrack/utils/theme.dart';
import 'package:pesatrack/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authp.AuthProvider()),
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
        ChangeNotifierProvider(create: (_) => YearSummaryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => FeeProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeProvider()),
        ChangeNotifierProvider(create: (_) => YearBudgetSummaryProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseCategoryProvider())
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
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthentication();
    });
  }

  void _checkAuthentication() {
    // final navigator = Navigator.of(context, rootNavigator: true);
    // if (FirebaseAuth.instance.currentUser == null) {
    //   navigator.pushReplacement(MaterialPageRoute(builder: (_) {
    //     return const AuthPage();
    //   }));
    // } else {
    final trans = Provider.of<TransactionsProvider>(context, listen: false);
    trans.fetchTransactions();
    trans.fetchTransactionsHomePage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 31, 31, 32),
      statusBarIconBrightness: Brightness.light,
    ));

    // final authProvider = Provider.of<AuthProvider>(context);

    // if (authProvider.isLoading) {
    //   // Show loading screen while authentication check is in progress
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     scaffoldMessengerKey: rootScaffoldMessengerKey,
    //     home: const LoadingScreen(),
    //     theme: ThemeData(
    //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //       useMaterial3: true,
    //     ),
    //   );
    // }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      themeMode: ThemeMode.dark,
      darkTheme: AppThemes.darkTheme,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // If authenticated, show MainPage, else show AuthPage

      home: FirebaseAuth.instance.currentUser == null
          ? const AuthPage()
          : const MainPage(),
      // home: authProvider.isAuthenticated ? const MainPage() : const AuthPage(),
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Check if the user is authenticated
    if (FirebaseAuth.instance.currentUser == null) {
      // Redirect to AuthPage if not authenticated
      Future.microtask(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthPage()),
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
        title: 'Budget',
      ),
      TabItem(
        icon: Icons.person,
        title: 'Profile',
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          const HomeScreen(),
          const AllTransactions(),
          // TrackTransactionsPage(),
          const HomeScreen(),
          const MorePages(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: BottomBarCreative(
        items: items,
        backgroundColor: Theme.of(context).colorScheme.background,
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
  const LoadingScreen({super.key});
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
