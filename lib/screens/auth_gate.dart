import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/main.dart'; 
import 'package:test1/screens/login_screen.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/loading_indicator.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
 final AuthController authController = Get.put(locator<AuthController>());

    return Obx(() {
      if (!authController.isAuthCheckComplete.value) {
        return const LoadingIndicator();
      }

      return authController.user.value != null
          ? MainWrapper()
          : const LoginScreen();
    });
  }
}
