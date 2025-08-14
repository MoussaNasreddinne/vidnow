import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/widgets/animated_fade_in.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/profile_content.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController authController = locator<AuthController>();
  final AuthService authService = locator<AuthService>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final user = authController.user.value;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const VidNowAppBar(),
        body: SingleChildScrollView(
          child: AnimatedFadeIn(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: user != null ? authService.getUserProfile(user.uid) : Future.value(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(heightFactor: 15, child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                  return ProfileContent(
                    theme: theme,
                    isDarkMode: isDarkMode,
                    username: 'Error Loading Profile',
                    email: 'Please try again later',
                    imageUrl: "https://i.imgur.com/EbocMzS.jpeg",
                  );
                }

                final userData = snapshot.data!;
                final profileImageUrl = user?.photoURL ?? userData['photoUrl'] ?? "https://i.imgur.com/EbocMzS.jpeg";

                return ProfileContent(
                  theme: theme,
                  isDarkMode: isDarkMode,
                  username: userData['username'] ?? 'No Username',
                  email: userData['email'] ?? 'No Email',
                  imageUrl: profileImageUrl,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}