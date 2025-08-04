import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define text color for selected/unselected states
    final Color selectedTextColor = Colors.white; // Always white on primary color
    final Color unselectedTextColor = isDarkMode ? Colors.white : Colors.black;

    // Conditionally create the button style
    final ButtonStyle buttonStyle = isSelected
        // STYLE WHEN SELECTED
        ? ElevatedButton.styleFrom(
            backgroundColor: theme.primaryColor,
            foregroundColor: selectedTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )
        // STYLE WHEN NOT SELECTED (uses the default from the theme)
        : theme.elevatedButtonTheme.style!.copyWith(
            // Explicitly set the foreground color for the unselected state
            // to ensure it respects the theme correctly.
            foregroundColor: WidgetStateProperty.all(unselectedTextColor), // <-- CORRECTED
          );

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withAlpha(150),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: buttonStyle, // Apply the corrected conditional style
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? selectedTextColor : unselectedTextColor,
            ),
            child: Text(name),
          ),
        ),
      ),
    );
  }
}