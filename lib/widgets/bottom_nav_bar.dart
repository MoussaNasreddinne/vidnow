import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/widgets/animated_nav_destination.dart';
import 'package:test1/service_locator.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavController n = locator<NavController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // rebuilds the widget when the selected index changes.
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.black : Colors.grey,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          height: 70,
          indicatorColor: theme.primaryColor,
          elevation: 10,

          backgroundColor: isDarkMode
              ? const Color.fromARGB(255, 20, 0, 50)
              : Colors.white,
          selectedIndex: n.currentIndex.value,
          shadowColor: Colors.transparent,
          onDestinationSelected: (value) {
            n.changeIndex(value);
          },
          destinations: [
            AnimatedNavDestination(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              isSelected: n.currentIndex.value == 0,
            ),
            AnimatedNavDestination(
              icon: Icons.favorite_outlined,
              selectedIcon: Icons.favorite,
              isSelected: n.currentIndex.value == 1,
            ),
            AnimatedNavDestination(
              icon: Icons.tv_outlined,
              selectedIcon: Icons.tv,
              isSelected: n.currentIndex.value == 2,
            ),
            AnimatedNavDestination(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              isSelected: n.currentIndex.value == 3,
            ),
          ],
        ),
      ),
    );
  }
}
