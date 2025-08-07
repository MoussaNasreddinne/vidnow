import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final _languageKey = 'appLanguage';
  late final Rx<Locale> currentLocale;
  final String _defaultLanguageCode;

  LanguageController({required String defaultLanguageCode})
      : _defaultLanguageCode = defaultLanguageCode {
    currentLocale = Locale(_defaultLanguageCode).obs;
  }

  @override
  void onInit() {
    super.onInit();
    _loadLanguageFromPrefs();
  }

  //loads the saved langauge from shared preferences on startup
  Future<void> _loadLanguageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString(_languageKey);
    if (languageCode != null) {
      currentLocale.value = Locale(languageCode);
    }
  }

  // Saves the selected language to SharedPreferences.
  Future<void> _saveLanguageToPrefs(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  void changeLanguage(Locale locale) {
    Get.updateLocale(locale);
    currentLocale.value = locale;
    _saveLanguageToPrefs(locale.languageCode);
  }

  bool isArabic() {
    return currentLocale.value.languageCode == 'ar';
  }
}