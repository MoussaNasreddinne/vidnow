import 'package:flutter/material.dart';

class AnimatedNavDestination extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;

  const AnimatedNavDestination({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Color selectedColor = Colors.white;
    final Color unselectedColor = isDarkMode ? Colors.white70 : Colors.black54;

    return NavigationDestination(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isSelected ? selectedIcon : icon,
          key: ValueKey<bool>(isSelected),
          color: isSelected ? selectedColor : unselectedColor,
        ),
      ),
      selectedIcon: Icon(selectedIcon, color: selectedColor),
      label: "",
    );
  }
}
// An animated navigation destination icon for the bottom navigation bar