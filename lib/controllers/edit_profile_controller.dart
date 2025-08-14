import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/controllers/auth_controller.dart';

class EditProfileController extends GetxController {
  final AuthService _authService = locator<AuthService>();
  final AuthController _authController = locator<AuthController>();

  final usernameController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _authController.user.value;
    if (user != null) {
      final userProfile = await _authService.getUserProfile(user.uid);
      if (userProfile != null) {
        usernameController.text = userProfile['username'] ?? '';
      }
    }
  }

  Future<void> updateProfile() async {
    final user = _authController.user.value;
    if (user == null) {
      CustomSnackbar.showErrorCustomSnackbar(
          title: 'Error', message: 'You must be logged in to do this.');
      return;
    }

    if (newPasswordController.text.isNotEmpty &&
        newPasswordController.text != confirmPasswordController.text) {
      CustomSnackbar.showErrorCustomSnackbar(
          title: 'Error', message: 'Passwords do not match.');
      return;
    }

    isLoading(true);
    try {
      await _authService.updateUserProfile(
        uid: user.uid,
        username: usernameController.text,
        newPassword: newPasswordController.text.isNotEmpty
            ? newPasswordController.text
            : null,
      );
      Get.back(); 
    } catch (e) {
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}