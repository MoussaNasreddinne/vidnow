import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/screens/videostream.dart';
import 'package:test1/controllers/favorites_controller.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/snackbar.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = locator<FavoritesController>();
    final VideoApiService apiService = locator<VideoApiService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: VidNowAppBar(),
        body: Obx(() {
          // rebuilds the body based on the state of the favorites list
          if (controller.isLoadingFavorites.value &&
              controller.favoriteVideos.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (controller.favoriteVideos.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'noFavoritesAdded'.tr,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          // AnimatedList provides animations for item additions and removals
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
                      // Fetches the stream URL if it's not already available.
                      try {
                        Get.dialog(
                          const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          ),
                          barrierDismissible: false,
                        );
                        finalVideoUrl = await apiService.getStreamUrl(video.id);
                        Get.back();
                      } catch (e) {
                        Get.back();

                        CustomSnackbar.showErrorCustomSnackbar(
                          title: 'error',
                          message: 'failedToGetVideoStream'.trParams({
                            'error': e.toString().split(':')[0],
                          }),
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
