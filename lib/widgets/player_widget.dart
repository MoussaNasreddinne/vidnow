import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayerWidget extends StatelessWidget {
  final bool isLoading;
  final ChewieController? chewieController;
  final AnimationController fadeController;
  final Animation<double> fadeAnimation;
  final String statusKey;
  final String videoId;

  const PlayerWidget({
    super.key,
    required this.isLoading,
    required this.chewieController,
    required this.fadeController,
    required this.fadeAnimation,
    required this.statusKey,
    required this.videoId,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: fadeController,
                curve: Curves.easeInOut,
              ),
            ),
            child: const CircularProgressIndicator(color: Colors.red),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: fadeAnimation.value,
                child: Text(
                  statusKey.tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ],
      );
    } else if (chewieController != null &&
        chewieController!.videoPlayerController.value.isInitialized) {
      return FadeTransition(
        opacity: fadeAnimation,
        child: Hero(
          tag: 'video-thumbnail-$videoId',
          child: Chewie(controller: chewieController!),
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber,
            color: Colors.orange,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            statusKey.contains('Error')
                ? statusKey
                : 'playbackCouldNotBeStarted'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }
  }
}