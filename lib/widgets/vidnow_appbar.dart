import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/theme_controller.dart';
import 'package:test1/screens/search_screen.dart';
import 'package:test1/service_locator.dart';

class VidNowAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = const Size.fromHeight(40);
  const VidNowAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = locator<ThemeController>();
    return AppBar(
      leading: PopupMenuButton<Locale>(
        icon: Icon(
          Icons.language,
          color: Theme.of(context).appBarTheme.iconTheme?.color,
        ),
        onSelected: (locale) {
          Get.updateLocale(locale);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
          PopupMenuItem<Locale>(
            value: const Locale('en'),
            child: Text('languageEnglish'.tr),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('ar'),
            child: Text('languageArabic'.tr),
          ),
          PopupMenuItem<Locale>(
            value: const Locale('fr'),
            child: Text('French'.tr),
          ),
        ],
      ),
      toolbarHeight: preferredSize.height,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'appName'.tr,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      centerTitle: true,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Get.to(() => const SearchScreen());
          },
        ),

        Obx(
          () => IconButton(
            icon: Icon(
              themeController.isDarkMode.value
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
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