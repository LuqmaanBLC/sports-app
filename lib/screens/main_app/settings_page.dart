import 'package:flutter/material.dart';
import '../../theme_controller.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController controller;

  const SettingsPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SettingsSection(
            title: "Appearance",
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue:
                controller.themeMode,
                onChanged: (value) =>
                    controller.setThemeMode(
                        value!),
                title:
                const Text("Use System Theme"),
                secondary:
                const Icon(Icons.phone_android),
                activeColor:
                const Color(0xFF2ECC71),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue:
                controller.themeMode,
                onChanged: (value) =>
                    controller.setThemeMode(
                        value!),
                title:
                const Text("Light Mode"),
                secondary:
                const Icon(Icons.light_mode),
                activeColor:
                const Color(0xFF2ECC71),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue:
                controller.themeMode,
                onChanged: (value) =>
                    controller.setThemeMode(
                        value!),
                title:
                const Text("Dark Mode"),
                secondary:
                const Icon(Icons.dark_mode),
                activeColor:
                const Color(0xFF2ECC71),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Padding(
      padding:
      const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Container(
            margin:
            const EdgeInsets.only(top: 12),
            padding:
            const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1C1C1F) // subtle grey
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              ),
            ),
            child: Column(
              children: children,
            ),
          ),

          // Title breaking border
          Positioned(
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: theme.scaffoldBackgroundColor,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
