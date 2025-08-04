import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/theme_controller.dart';
import 'package:test1/service_locator.dart';

class VidNowAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(40);

  const VidNowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = locator<ThemeController>();

    return AppBar(
      toolbarHeight: preferredSize.height,
      // Use theme colors and styles
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Text(
        "VidNow",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: true,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      actions: [
        Obx(
          () => IconButton(
            icon: Icon(
              themeController.isDarkMode.value
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            // Use the icon theme color from the AppBarTheme
            color: Theme.of(context).appBarTheme.iconTheme?.color,
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
        ),
      ],
    );
  }
}