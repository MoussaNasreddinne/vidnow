import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/forgot_password_controller.dart';
import 'package:test1/widgets/gradient_background.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController controller = Get.put(ForgotPasswordController());
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark; // ADDED: Check for dark mode

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('resetPassword'.tr),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'forgotPasswordInstruction'.tr,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    // MODIFIED: Use a theme-aware semi-transparent color
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.sendPasswordResetLink,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text('sendResetLink'.tr, style: const TextStyle(fontSize: 18)),
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