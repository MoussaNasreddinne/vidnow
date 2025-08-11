import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/widgets/snackbar.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = locator<AuthService>();

  // Controller for the email text field
  final emailController = TextEditingController();

  // Tracks the loading state for the reset link request
  var isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Handles sending the password reset link.
  Future<void> sendPasswordResetLink() async {
    // Prevents sending if the email field is empty.
    if (emailController.text.trim().isEmpty) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Please enter your email address',
      );
      return;
    }

    isLoading(true);
    try {
      await _authService.sendPasswordResetEmail(emailController.text);
    } finally {
      isLoading(false);
    }
  }
}
