import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/controllers/theme_controller.dart'; // ADDED

class AuthController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  // ADDED: Get an instance of the ThemeController.
  final ThemeController _themeController = locator<ThemeController>();

  final Rxn<User> user = Rxn<User>();
  final RxBool isAuthCheckComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _authService.authStateChanges.listen((firebaseUser) {
      user.value = firebaseUser;

      // MODIFIED: Trigger theme changes based on auth state.
      if (firebaseUser != null) {
        // User is logged in, load their specific theme.
        _themeController.loadUserTheme(firebaseUser.uid);
      } else {
        // User is logged out, reset to the default theme.
        _themeController.resetToDefaultTheme();
      }

      if (!isAuthCheckComplete.value) {
        isAuthCheckComplete.value = true;
      }
    });
  }
}