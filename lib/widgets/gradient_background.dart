import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 16, 0, 61),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}