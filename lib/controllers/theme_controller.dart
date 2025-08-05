import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final _isDarkModeKey = 'isDarkMode';
  var isDarkMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }
  // Gets the current theme mode based on the isDarkMode
  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_isDarkModeKey) ?? true; 
  }

  Future<void> _saveThemeToPrefs(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToPrefs(isDarkMode.value);
    Get.changeThemeMode(theme);
  }
}