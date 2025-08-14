import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/edit_profile_controller.dart';
import 'package:test1/widgets/gradient_background.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('editProfile'.tr),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Implement image picker
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.primaryColor,
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 50),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: controller.usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password (optional)',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black : Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                          onPressed: controller.updateProfile,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save Changes',
                              style: TextStyle(fontSize: 18)),
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
