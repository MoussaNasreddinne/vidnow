
import 'package:chewie/chewie.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:video_player/video_player.dart';

class VideoStreamController extends GetxController with GetSingleTickerProviderStateMixin {
  final Video video;
  final String videoUrl;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  final isLoading = true.obs;
  final statusKey = 'videoPlayerInitializing'.obs;
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  VideoStreamController({required this.video, required this.videoUrl});

  @override
  void onInit() {
    super.onInit();
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeIn));
    initializePlayer();
  }

  @override
  void onClose() {
    debugPrint('VideoStreamController: Disposing controllers.');
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    chewieController?.removeListener(_onFullscreenToggle);
    fadeController.dispose();
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.onClose();
  }

  Future<void> initializePlayer() async {
    statusKey.value = 'videoPlayerParsingUrl';
    try {
      String cleanUrl = videoUrl.replaceAll('"', '').trim();
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(cleanUrl));

      statusKey.value = 'videoPlayerLoadingVideo';
      await videoPlayerController!.initialize();

      if (videoPlayerController!.value.hasError) {
        throw Exception(
            'Video player error: ${videoPlayerController!.value.errorDescription}');
      }

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade700,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              'couldNotPlayVideo'.trParams({'errorMessage': errorMessage}),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          );
        },
      );

      chewieController!.addListener(_onFullscreenToggle);

      FirebaseAnalytics.instance.logEvent(
        name: 'video_play',
        parameters: {
          'video_id': video.id,
          'video_title':
              video.title.length > 100 ? video.title.substring(0, 100) : video.title,
          'video_category': video.categoryName ?? 'none',
          'is_premium': video.isPremium.toString(),
        },
      );

      fadeController.forward();
      isLoading.value = false;
      statusKey.value = 'videoPlayerReady';
    } catch (e) {
      debugPrint("VideoStreamController: Error during initializePlayer: $e");
      isLoading.value = false;
      statusKey.value = 'couldNotPlayVideo'.trParams({'errorMessage': e.toString()});
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'playbackError'.tr,
        message: statusKey.value,
      );
    }
  }

  void _onFullscreenToggle() {
    if (chewieController != null) {
      final bool isFullScreen = chewieController!.isFullScreen;
      if (isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }
  }
}