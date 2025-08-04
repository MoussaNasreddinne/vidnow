import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/button_controller.dart';
import 'package:test1/controllers/rec_controller.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/screens/videostream.dart';
import 'package:test1/widgets/Category_chip.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/widgets/loading_indicator.dart';
import 'package:test1/service_locator.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonController buttonController = locator<ButtonController>();
    final RecommendationController recController =
        locator<RecommendationController>();
    final VideoApiService apiService = locator<VideoApiService>();

    return Obx(() {
      if (recController.isLoading.value &&
          recController.currentRecommendations.isEmpty) {
        return const LoadingIndicator();
      }

      return GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: VidNowAppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The category chips are built dynamically
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: recController.categoryNames.map((name) {
                        final index = recController.categoryNames.indexOf(name);
                        return CategoryChip(
                          name: name,
                          isSelected:
                              buttonController.selectedIndex.value == index,
                          onTap: () {
                            buttonController.selectButton(index);
                            recController.selectedCategoryIndex.value = index;
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                if (recController.isLoading.value)
                  const Expanded(child: Center(child: LoadingIndicator()))
                else if (recController.currentRecommendations.isEmpty &&
                    !recController.isLoading.value)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "No videos found for this category.",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  )
                else
                  Expanded(
                    // The list builder now uses the computed property
                    child: ListView.builder(
                      itemCount: recController.currentRecommendations.length,
                      itemBuilder: (context, index) {
                        final video =
                            recController.currentRecommendations[index];
                        return VideoCard(
                          recommendation: video,
                          onTap: () async {
                            String finalVideoUrl = video.streamUrl ?? '';
                            if (finalVideoUrl.isEmpty) {
                              try {
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.red,
                                    ),
                                  ),
                                  barrierDismissible: false,
                                );
                                finalVideoUrl =
                                    await apiService.getStreamUrl(video.id);
                                Get.back();
                              } catch (e) {
                                Get.back();
                                Get.snackbar(
                                  'Error',
                                  'Failed to get video stream: $e',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                debugPrint('Error getting stream URL: $e');
                                return;
                              }
                            }
                            Get.to(() =>
                                VideoPlayerScreen(videoUrl: finalVideoUrl));
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}