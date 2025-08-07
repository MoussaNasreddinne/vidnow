import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/main.dart'; 
import 'package:test1/screens/login_screen.dart';
import 'package:test1/widgets/loading_indicator.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate or find the AuthController. It will persist across rebuilds.
    final AuthController authController = Get.put(AuthController());

    // rebuild depending on controller state
    return Obx(() {
      // Show loading indicator only until the initial auth check is complete
      if (!authController.isAuthCheckComplete.value) {
        return const LoadingIndicator();
      }

      // After the check is complete, decide which screen to show based on user state
      return authController.user.value != null
          ? MainWrapper()
          : const LoginScreen();
    });
  }
}
