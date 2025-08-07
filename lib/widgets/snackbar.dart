import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  
  static void showErrorCustomSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
  static void showSuccessCustomSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(15),
      duration: const Duration(seconds: 4),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}