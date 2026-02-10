import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

/// ---- Theme additions ----
import 'screens/main_app/settings_page.dart';
import 'theme_controller.dart';
/// --------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ftbyuhfguukwtxjbotzv.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ0Ynl1aGZndXVrd3R4amJvdHp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAyNzg3MzEsImV4cCI6MjA4NTg1NDczMX0.txKKxsbsIBqs-SGHDP59LRfXZ2YnH26aGz9ejb1OCpg',
  );

  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(SportsApp(isLoggedIn: isLoggedIn));
}

/// ---- Converted to Stateful for theme handling ----
class SportsApp extends StatefulWidget {
  final bool isLoggedIn;
  const SportsApp({super.key, required this.isLoggedIn});

  @override
  State<SportsApp> createState() => _SportsAppState();
}

class _SportsAppState extends State<SportsApp> {
  final ThemeController _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Sports App',
          debugShowCheckedModeBanner: false,

          /// ---- Light/Dark theme support ----
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: _themeController.themeMode,
          /// -----------------------------------

          initialRoute:
          widget.isLoggedIn ? '/mainApp' : '/getStarted',

          routes: {
            '/getStarted': (context) => GetStartedScreen(),
            '/login': (context) => LoginScreen(),
            '/signup': (context) => SignUpScreen(),
            '/forgotPassword': (context) =>
                ForgotPasswordScreen(),
            '/register': (context) => RegisterScreen(),
            '/mainApp': (context) => MainAppShell(),

            /// Theme settings screen
            '/settings': (context) =>
                SettingsPage(controller: _themeController),
          },
        );
      },
    );
  }
}

/// Main shell with bottom navigation
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
