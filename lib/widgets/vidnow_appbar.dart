import 'package:flutter/material.dart';

class VidNowAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(40);

  const VidNowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: const Color.fromARGB(255, 145, 0, 0),
      title: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 10,
              color: Colors.black,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: const Text("VidNow"),
      ),
      centerTitle: true,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
    );
  }
}