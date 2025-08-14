import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/main.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/controllers/theme_controller.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController(); 
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose(); 
    super.onClose();
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear(); 
  }

Future<void> signInWithGoogle() async {
    isLoading(true);
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        final themeController = locator<ThemeController>();
        await themeController.loadUserTheme(user.uid);
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> login() async {
    isLoading(true);
    try {
      final user = await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        final themeController = locator<ThemeController>();
        await themeController.loadUserTheme(user.uid);

      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> signUp() async {
    if (usernameController.text.trim().isEmpty) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Please enter a username',
      );
      return;
    }

    isLoading(true);
    try {
      final user = await _authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        usernameController.text, 
      );
      if (user != null) {
        CustomSnackbar.showSuccessCustomSnackbar(
          title: 'Account Created',
          message: 'Please log in with your new credentials.',
        );
        await _authService.signOut();
        print('sign out');
      }
    } finally {
      isLoading(false);
    }
  }
}
