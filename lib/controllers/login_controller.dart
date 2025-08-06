import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/main.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = locator<AuthService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    isLoading(true);
    try {
      final user = await _authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        // Navigate to the main app, clearing the auth screens from history
        Get.offAll(() => MainWrapper());
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> signUp() async {
    isLoading(true);
    try {
      final user = await _authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        // Navigate to the main app on successful sign-up
        Get.offAll(() => MainWrapper());
      }
    } finally {
      isLoading(false);
    }
  }
  
}
