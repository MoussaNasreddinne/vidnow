
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/controllers/auth_controller.dart';

class ThemeController extends GetxController {
  var isDarkMode = true.obs;
  final bool _defaultIsDark;

  ThemeController({required bool defaultIsDark}) : _defaultIsDark = defaultIsDark {
    isDarkMode.value = _defaultIsDark;
  }

  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadUserTheme(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .get();
      if (doc.exists && doc.data()!.containsKey('is_dark_mode')) {
        isDarkMode.value = doc.data()!['is_dark_mode'];
      } else {
        isDarkMode.value = _defaultIsDark;
      }
    } catch (e) {
      debugPrint("Error loading user theme: $e");
      isDarkMode.value = _defaultIsDark;
    } finally {
      Get.changeThemeMode(theme);
    }
  }

  Future<void> _saveThemeToFirestore(String userId, bool isDark) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .set({'is_dark_mode': isDark}, SetOptions(merge: true));
  }

  void resetToDefaultTheme() {
    isDarkMode.value = _defaultIsDark;
    Get.changeThemeMode(theme);
  }

  void toggleTheme() {
    final authController = locator<AuthController>();
    final userId = authController.user.value?.uid;

    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(theme);
    // Only save the preference if a user is logged in.
    if (userId != null) {
      _saveThemeToFirestore(userId, isDarkMode.value);
    }
  }
}