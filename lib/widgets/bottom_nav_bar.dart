import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/widgets/animated_nav_destination.dart'; 
import 'package:test1/service_locator.dart'; // Import the locator

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the NavController instance from the get_it locator
    final NavController n = locator<NavController>();

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: NavigationBar(
          height: 70,
          indicatorColor: const Color.fromARGB(255, 145, 0, 0),
          elevation: 10,
          backgroundColor: const Color.fromARGB(0, 58, 35, 121),
          selectedIndex: n.currentIndex.value,
          shadowColor: const Color.fromARGB(0, 145, 0, 0),
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