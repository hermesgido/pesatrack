import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesatrack/providers/authprovider.dart';
import 'package:pesatrack/providers/budgets_provider.dart';
import 'package:pesatrack/providers/categories_provider.dart';
import 'package:pesatrack/providers/transactions_provider.dart';
import 'package:pesatrack/providers/year_summary_provider.dart';
import 'package:pesatrack/screens/analytics/track_page.dart';
import 'package:pesatrack/screens/auth/login.dart';
import 'package:pesatrack/screens/home_page.dart';
import 'package:pesatrack/screens/morepages/more_pages.dart';
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
        ChangeNotifierProvider(create: (_) => TransactionsProvider()),
        ChangeNotifierProvider(create: (_) => YearSummaryProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
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
    // Check if the user is authenticated
    Provider.of<AuthProvider>(context, listen: false)
        .checkAuthentication(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final trans = Provider.of<TransactionsProvider>(context, listen: false);
      trans.fetchTransactions();
      trans.fetchTransactionsHomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 31, 31, 32),
      statusBarIconBrightness: Brightness.light,
    ));

    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      // Show loading screen while authentication check is in progress
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swiping
        children: [
          const HomeScreen(),
          TrackTransactionsPage(),
          const HomeScreen(), // Keep the current page active instead of showing an empty page
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

class PinEntryScreen extends StatefulWidget {
  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final TextEditingController _pinController = TextEditingController();
  final int _pinLength = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Enter PIN Code',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildPinInput(),
              const SizedBox(height: 20),
              _buildNumberPad(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput() {
    return Container(
      width: 300,
      child: TextField(
        controller: _pinController,
        obscureText: true,
        maxLength: _pinLength,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 24),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.black,
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == _pinLength) {
            // Handle PIN code input completion
            _handlePinEntered(value);
          }
        },
      ),
    );
  }

  Widget _buildNumberPad() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index < 9) {
          return _buildNumberButton(index + 1);
        } else if (index == 9) {
          return Container(); // Spacer for layout
        } else if (index == 10) {
          return _buildNumberButton(0);
        } else {
          return _buildBackspaceButton();
        }
      },
    );
  }

  Widget _buildNumberButton(int number) {
    return ElevatedButton(
      onPressed: () {
        if (_pinController.text.length < _pinLength) {
          _pinController.text += number.toString();
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return ElevatedButton(
      onPressed: () {
        if (_pinController.text.isNotEmpty) {
          _pinController.text =
              _pinController.text.substring(0, _pinController.text.length - 1);
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
      ),
      child: const Icon(Icons.backspace, size: 24),
    );
  }

  void _handlePinEntered(String pin) {
    // Handle the logic when the PIN code is entered
    // For example, you can navigate to another screen or validate the PIN
    print('Entered PIN: $pin');
    // Navigate to another screen
    // Navigator.pushReplacementNamed(context, '/nextScreen');
  }
}
