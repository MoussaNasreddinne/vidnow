
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/watch_history_controller.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/loading_indicator.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/service_locator.dart';

class WatchHistoryScreen extends StatelessWidget {
  const WatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WatchHistoryController controller = Get.put(WatchHistoryController());
    final VideoApiService apiService = locator<VideoApiService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('watchHistory'.tr),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingIndicator();
          }
          if (controller.historyVideos.isEmpty) {
            return Center(
              child: Text(
                'noWatchHistory'.tr,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.historyVideos.length,
            itemBuilder: (context, index) {
              final video = controller.historyVideos[index];
              return VideoCard(
                recommendation: video,
                onTap: () => apiService.playVideo(video),
              );
            },
          );
        }),
      ),
    );
  }
}