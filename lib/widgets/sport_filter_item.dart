import 'package:flutter/material.dart';

class SportFilterItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SportFilterItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        height: 90,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12, // slightly reduced padding
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2ECC71)
                : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? null
                : Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: const Color(0xFF2ECC71).withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected
                    ? Colors.black
                    : theme.colorScheme.onBackground,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : theme.colorScheme.onBackground,
                    fontSize: 12, // ✅ smaller font
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // ✅ prevents overflow
                  maxLines: 1, // ✅ keeps text on one line
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
