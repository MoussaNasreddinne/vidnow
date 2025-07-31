import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/screens/videostream.dart';
import 'package:test1/controllers/favorites_controller.dart';
import 'package:test1/service_locator.dart'; // Import the locator

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve instances from the locator
    final FavoritesController controller = locator<FavoritesController>();
    final VideoApiService apiService = locator<VideoApiService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: VidNowAppBar(),
        body: Obx(() {
          // Only show loading indicator on initial load
          if (controller.isLoadingFavorites.value && controller.favoriteVideos.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }
          
          // Empty state
          if (controller.favoriteVideos.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "No favorites added yet. Click the heart icon on a video to add it!",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return AnimatedList(
            key: controller.listKey, 
            padding: const EdgeInsets.all(8.0),
            initialItemCount: controller.favoriteVideos.length,
            itemBuilder: (context, index, animation) {
              final video = controller.favoriteVideos[index];
              return SizeTransition(
                sizeFactor: animation,
                child: VideoCard(
                  recommendation: video,
                  onTap: () async {
                    String finalVideoUrl = video.streamUrl ?? '';
                    if (finalVideoUrl.isEmpty) {
                      try {
                        Get.dialog(
                          const Center(child: CircularProgressIndicator(color: Colors.red)),
                          barrierDismissible: false,
                        );
                        finalVideoUrl = await apiService.getStreamUrl(video.id);
                        Get.back();
                      } catch (e) {
                        Get.back();
                        Get.snackbar(
                          'Error', 
                          'Failed to get video stream: ${e.toString().split(':')[0]}',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        return;
                      }
                    }
                    Get.to(() => VideoPlayerScreen(videoUrl: finalVideoUrl));
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}