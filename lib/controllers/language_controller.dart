import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/service_locator.dart';

class LanguageController extends GetxController {
  late final Rx<Locale> currentLocale;
  final String _defaultLanguageCode;

  LanguageController({required String defaultLanguageCode})
      : _defaultLanguageCode = defaultLanguageCode {
    currentLocale = Locale(_defaultLanguageCode).obs;
  }

  // Loads the user's language from Firestore.
  Future<void> loadUserLanguage(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('preferences')
          .doc('settings')
          .get();
      if (doc.exists && doc.data()!.containsKey('language_code')) {
        final languageCode = doc.data()!['language_code'];
        currentLocale.value = Locale(languageCode);
        Get.updateLocale(currentLocale.value);
      } else {
        resetToDefaultLanguage();
      }
    } catch (e) {
      debugPrint("Error loading user language: $e");
      resetToDefaultLanguage();
    }
  }

  // Saves the selected language to Firestore.
  Future<void> _saveLanguageToFirestore(String userId, String languageCode) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .set({'language_code': languageCode}, SetOptions(merge: true));
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
    currentLocale.value = locale;
    final authController = locator<AuthController>();
    final userId = authController.user.value?.uid;
    if (userId != null) {
      _saveLanguageToFirestore(userId, locale.languageCode);
    }
  }
  
  void resetToDefaultLanguage() {
    currentLocale.value = Locale(_defaultLanguageCode);
    Get.updateLocale(currentLocale.value);
  }

  bool isArabic() {
    return currentLocale.value.languageCode == 'ar';
  }
}