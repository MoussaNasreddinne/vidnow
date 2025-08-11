import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:test1/screens/forgot_password_screen.dart'; 
import 'package:test1/screens/signup_screen.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/gradient_background.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final LoginController controller = locator<LoginController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'appName'.tr,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 40),
                ),
                const SizedBox(height: 50),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'email'.tr, 
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    labelText: 'password'.tr, 
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => const ForgotPasswordScreen());
                    },
                    child: Text('forgotPassword'.tr, style: TextStyle(color: theme.primaryColor)),
                  ),
                ),
                const SizedBox(height: 10),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('login'.tr, style: const TextStyle(fontSize: 18)), 
                        ),
                      )),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    controller.emailController.clear();
                    controller.passwordController.clear();
                    Get.to(() => const SignUpScreen());
                  },
                  child: Text("dontHaveAccount".tr, style: TextStyle(color: theme.primaryColor),textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}