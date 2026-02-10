import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,

      // Theme-aware background
      backgroundColor:
      theme.bottomAppBarTheme.color ??
          theme.scaffoldBackgroundColor,

      // Keep app accent color
      selectedItemColor:
      const Color(0xFF2ECC71),

      // Adaptive inactive color
      unselectedItemColor: isDark
          ? Colors.grey
          : Colors.grey.shade600,

      showUnselectedLabels: true,

      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites'),
        BottomNavigationBarItem(
            icon:
            Icon(Icons.sports_soccer),
            label: 'Predictions'),
        BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'),
      ],
    );
  }
}
