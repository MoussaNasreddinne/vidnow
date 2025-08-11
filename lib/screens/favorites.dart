// lib/screens/favorites.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/controllers/favorites_controller.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/loading_indicator.dart';

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
          if (controller.isLoadingFavorites.value &&
              controller.favoriteVideos.isEmpty) {
            return const LoadingIndicator();
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
                  onTap: () => apiService.playVideo(video),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}