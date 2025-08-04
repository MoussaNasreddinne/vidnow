import 'package:flutter/material.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme to make decisions based on it
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Use the reusable, theme-aware AppBar
        appBar: const VidNowAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      // Use the theme's primary color
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          // Use a theme-aware shadow color with the updated withAlpha method
                          color: isDarkMode
                              ? Colors.black.withAlpha(179) // Opacity ~70%
                              : Colors.grey.withAlpha(128), // Opacity 50%
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
                "User Name",
                // Use the theme's text style
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 5),
              Text(
                "user@example.com",
                // Use the theme's text style
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Replace the hardcoded container with a theme-aware Card
              Card(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.075),
                // The card's color will be automatically handled by the theme
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.history_outlined,
                      title: "Watch History",
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () {},
                      context: context,
                    ),
                    _buildProfileOption(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {},
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

  // Helper widget for building list items in the profile
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
            // Use the updated withAlpha method
            color: theme.iconTheme.color?.withAlpha(153), 
            size: 16,
          ),
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            // Use the theme's divider color
            color: theme.dividerColor,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}