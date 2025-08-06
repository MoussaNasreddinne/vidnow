import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const VidNowAppBar(),
        body: SingleChildScrollView(
          child: Column(
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
                      child: Image.asset(
                        "assets/images/profile.jpg",
                        fit: BoxFit.cover,
                        height: 150,
                        width: 150,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'profileUserName'.tr, 
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 5),
              Text(
                'profileUserEmail'.tr, 
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
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      title: 'editProfile'.tr, 
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.settings_outlined,
                      title: 'settings'.tr, 
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.history_outlined,
                      title: 'watchHistory'.tr, 
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_outlined,
                      title: 'notifications'.tr,
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: 'helpAndSupport'.tr, 
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.logout,
                      title: 'logout'.tr, 
                      onTap: () {
                        locator<AuthService>().signOut();
                      },
                      isLast: true,
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: theme.iconTheme.color),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: theme.iconTheme.color?.withAlpha(153), 
            size: 16,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            color: theme.dividerColor,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}
