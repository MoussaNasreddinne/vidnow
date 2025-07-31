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
    return NavigationDestination(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          isSelected ? selectedIcon : icon,
          key: ValueKey<bool>(isSelected),
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
      selectedIcon: Icon(selectedIcon, color: Colors.white),
      label: "",
    );
  }
}