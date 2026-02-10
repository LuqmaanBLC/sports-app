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
    return GestureDetector(
      onTap: onTap,
        child: SizedBox(
          width: 90, // fixed width
          height: 90, // fixed height
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18), // bigger padding
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2ECC71) // Green (selected)
                : const Color(0xFF2A2A2A), // Lighter Dark (unselected)
            borderRadius: BorderRadius.circular(20), // pill shape
            border: isSelected
                ? null
                : Border.all(color: Colors.grey.shade700, width: 1), // Subtle Border
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
            mainAxisAlignment: MainAxisAlignment.center, // center vertically
            crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
            children: [
              Icon(
                icon,
                size: 22, // bigger icon
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(height: 8), // spacing between icon and text
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 14, // bigger font
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center, // center text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
