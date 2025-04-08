import 'package:flutter/material.dart';
import 'package:nfc_app/widgets/app_text.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<AppBottomNavItem> items;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
              (index) => _buildNavItem(
            context,
            items[index],
            index == selectedIndex,
                () => onItemSelected(index),
            isDark,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      AppBottomNavItem item,
      bool isSelected,
      VoidCallback onTap,
      bool isDark,
      ) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = isDark
        ? Colors.white.withOpacity(0.6)
        : Colors.black.withOpacity(0.6);

    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            AppText(
              item.label,
              type: AppTextType.caption,
              color: isSelected ? selectedColor : unselectedColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ],
        ),
      ),
    );
  }
}

class AppBottomNavItem {
  final IconData icon;
  final String label;

  const AppBottomNavItem({
    required this.icon,
    required this.label,
  });
}
