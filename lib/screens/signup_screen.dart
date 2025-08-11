import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/service_locator.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final LoginController controller = locator<LoginController>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('createAccount'.tr), 
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                const SizedBox(height: 30),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('signUp'.tr, style: const TextStyle(fontSize: 18)), 
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}