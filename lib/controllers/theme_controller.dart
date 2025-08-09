import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test1/service_locator.dart'; // ADDED
import 'package:test1/controllers/auth_controller.dart'; // ADDED

class ThemeController extends GetxController {
  // MODIFIED: The key is now a prefix, not a full key.
  final _isDarkModeKeyPrefix = 'isDarkMode_';
  var isDarkMode = true.obs;
  final bool _defaultIsDark;
  ThemeController({required bool defaultIsDark}) : _defaultIsDark = defaultIsDark {
    // ADDED: Initialize with the default theme from Remote Config.
    isDarkMode.value = _defaultIsDark;
  }

  @override
  void onInit() {
    super.onInit();
    // REMOVED: No longer automatically loading theme from preferences on init.
    // _loadThemeFromPrefs(); 
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // MODIFIED: This method now loads a theme for a specific user ID.
  Future<void> loadUserTheme(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userThemeKey = '$_isDarkModeKeyPrefix$userId';
    // Loads the user's preference; if null, it uses the default from Remote Config.
    isDarkMode.value = prefs.getBool(userThemeKey) ?? _defaultIsDark;
    Get.changeThemeMode(theme);
  }

  // MODIFIED: This method now saves a theme for a specific user ID.
  Future<void> _saveThemeToPrefs(String userId, bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userThemeKey = '$_isDarkModeKeyPrefix$userId';
    await prefs.setBool(userThemeKey, isDark);
  }
  
  // ADDED: Method to reset the theme to the remote default.
  void resetToDefaultTheme() {
    isDarkMode.value = _defaultIsDark;
    Get.changeThemeMode(theme);
  }


  void toggleTheme() {
    // Get the current user's ID to save the theme preference.
    final authController = locator<AuthController>();
    final userId = authController.user.value?.uid;

    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(theme);

    // Only save the preference if a user is logged in.
    if (userId != null) {
      _saveThemeToPrefs(userId, isDarkMode.value);
    }
  }
}