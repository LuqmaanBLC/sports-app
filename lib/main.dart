import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase import
import 'screens/auth/get_started_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_app/home_screen.dart';
import 'screens/main_app/favorites_screen.dart';
import 'screens/main_app/predictions_tab_screen.dart';
import 'screens/main_app/history_screen.dart';
import 'screens/main_app/profile_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ftbyuhfguukwtxjbotzv.supabase.co',   // Replace with your Supabase project URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0Ynl1aGZndXVrd3R4amJvdHp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAyNzg3MzEsImV4cCI6MjA4NTg1NDczMX0.txKKxsbsIBqs-SGHDP59LRfXZ2YnH26aGz9ejb1OCpg',  // Replace with your Supabase anon public key
  );

  // Still check local login state (can later be replaced with Supabase auth)
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(SportsApp(isLoggedIn: isLoggedIn));
}

class SportsApp extends StatelessWidget {
  final bool isLoggedIn;
  const SportsApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isLoggedIn ? '/mainApp' : '/getStarted',
      routes: {
        '/getStarted': (context) => GetStartedScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgotPassword': (context) => ForgotPasswordScreen(),
        '/register': (context) => RegisterScreen(),
        '/mainApp': (context) => MainAppShell(),
      },
    );
  }
}

/// A simple shell that holds the BottomNavigationBar and shows pages.
/// We'll implement MainAppShell in widgets/bottom_nav_bar.dart
class MainAppShell extends StatefulWidget {
  @override
  _MainAppShellState createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen(),
    PredictionsTabScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
