import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';

// Manages the state and logic for the Forgot Password screen.
class ForgotPasswordController extends GetxController {
  // Accesses the authentication service.
  final AuthService _authService = locator<AuthService>();
  
  // Controller for the email text field.
  final emailController = TextEditingController();
  
  // Tracks the loading state for the reset link request.
  var isLoading = false.obs;

  @override
  void onClose() {
    // Disposes the text controller to prevent memory leaks.
    emailController.dispose();
    super.onClose();
  }

  // Handles sending the password reset link.
  Future<void> sendPasswordResetLink() async {
    // Prevents sending if the email field is empty.
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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