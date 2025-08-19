import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/screens/edit_profile_screen.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';
import 'package:test1/widgets/profile_option.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/screens/watch_history_screen.dart';
import 'package:test1/screens/comment_history_screen.dart';

class ProfileContent extends StatelessWidget {
  final ThemeData theme;
  final bool isDarkMode;
  final String username;
  final String email;
  final String imageUrl;

  const ProfileContent({
    super.key,
    required this.theme,
    required this.isDarkMode,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final authController = locator<AuthController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withAlpha(179)
                        : Colors.grey.withAlpha(128),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person,
                        size: 150, color: Colors.white);
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          username,
          style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 5),
        Text(
          email,
          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 30),
        Card(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.075),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              ProfileOption(
                icon: Icons.person_outline,
                title: 'editProfile'.tr,
                onTap: () {
                  final user = authController.user.value;
                  if (user != null &&
                      user.providerData
                          .any((info) => info.providerId == 'google.com')) {
                    CustomSnackbar.showErrorCustomSnackbar(
                      title: 'editProfileError'.tr,
                      message: 'googleUserCannotEditProfile'.tr,
                    );
                  } else {
                    Get.to(() => const EditProfileScreen());
                  }
                },
              ),
              ProfileOption(
                icon: Icons.settings_outlined,
                title: 'settings'.tr,
                onTap: () {},
              ),
              ProfileOption(
                icon: Icons.history_outlined,
                title: 'watchHistory'.tr,
                onTap: () {
                  Get.to(() => const WatchHistoryScreen());
                },
              ),
              ProfileOption(
                icon: Icons.comment_outlined,
                title: 'commentHistory'.tr,
                onTap: () {
                  Get.to(() => const CommentHistoryScreen());
                },
              ),
              ProfileOption(
                icon: Icons.help_outline,
                title: 'helpAndSupport'.tr,
                onTap: () {},
              ),
              ProfileOption(
                icon: Icons.delete_forever,
                title: 'deleteAccount'.tr,
                isDestructive: true,
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('deleteAccountConfirmationTitle'.tr),
                      content: Text('deleteAccountConfirmationMessage'.tr),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text('cancel'.tr),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); 
                            locator<AuthService>().deleteUserAccount();
                          },
                          child: Text(
                            'delete'.tr,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ProfileOption(
                icon: Icons.logout,
                title: 'logout'.tr,
                onTap: () {
                  locator<AuthService>().signOut();
                },
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}