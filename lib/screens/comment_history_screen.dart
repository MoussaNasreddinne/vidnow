// screens/comment_history_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/comment_history_controller.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/loading_indicator.dart';

class CommentHistoryScreen extends StatelessWidget {
  const CommentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CommentHistoryController controller =
        Get.put(CommentHistoryController());

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('commentHistory'.tr),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isNavigating.value || controller.isLoading.value) {
            return const LoadingIndicator();
          }
          if (controller.userComments.isEmpty) {
            return Center(
              child: Text(
                'noCommentsYet'.tr,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: controller.userComments.length,
            itemBuilder: (context, index) {
              final comment = controller.userComments[index];
              return Card(
                color: const Color.fromARGB(255, 30, 0, 70),
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: ListTile(
                  title: Text(comment.text,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    'On: ${comment.videoTitle ?? "a video"}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  onTap: () => controller.navigateToVideo(comment.videoId),
                  // Add the thumbnail to the trailing property
                  trailing: SizedBox(
                    width: 56,
                    height: 56,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: comment.thumbnailUrl != null &&
                              comment.thumbnailUrl!.isNotEmpty
                          ? Image.network(
                              comment.thumbnailUrl!,
                              fit: BoxFit.cover,
                              // Show a placeholder icon if the image fails to load
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported,
                                    color: Colors.white54);
                              },
                            )
                          // Show a placeholder for old comments without a thumbnail
                          : const Icon(Icons.movie_creation_outlined,
                              color: Colors.white54),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}