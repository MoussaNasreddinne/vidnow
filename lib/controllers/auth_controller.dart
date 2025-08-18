
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/language_controller.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/controllers/theme_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final ThemeController _themeController = locator<ThemeController>();
  final LanguageController _languageController = locator<LanguageController>();

  final Rxn<User> user = Rxn<User>();
  final RxBool isAuthCheckComplete = false.obs;
  final RxBool isPremiumUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen((firebaseUser) async {
      user.value = firebaseUser;

      if (firebaseUser != null) {
        // User is logged in, load their specific preferences.
        await _themeController.loadUserTheme(firebaseUser.uid);
        await _languageController.loadUserLanguage(firebaseUser.uid);
      } else {
        // User is logged out, reset to the default theme and language.
        _themeController.resetToDefaultTheme();
        _languageController.resetToDefaultLanguage();
      }

      if (!isAuthCheckComplete.value) {
        isAuthCheckComplete.value = true;
      }
    });
  }
}