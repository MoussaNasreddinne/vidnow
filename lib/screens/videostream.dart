import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/service_locator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  String _statusKey = 'videoPlayerInitializing';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _initializePlayer();
  }

  // Initializes the video player with the given URL
  Future<void> _initializePlayer() async {
    setState(() => _statusKey = 'videoPlayerParsingUrl');
    debugPrint(
      'VideoPlayerScreen: _initializePlayer called. URL: "${widget.videoUrl}"',
    );

    try {
      String cleanUrl = widget.videoUrl.replaceAll('"', '').trim();
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(cleanUrl),
      );

      setState(() => _statusKey = 'videoPlayerLoadingVideo');
      debugPrint(
        'VideoPlayerScreen: Attempting to initialize VideoPlayerController...',
      );
      await _videoPlayerController!.initialize();
      debugPrint(
        'VideoPlayerScreen: VideoPlayerController.initialize() completed.',
      );

      if (_videoPlayerController!.value.hasError) {
        final error = _videoPlayerController!.value.errorDescription;
        debugPrint(
          'VideoPlayerScreen: VideoPlayerController has error: $error',
        );
        throw Exception('Video player error: $error');
      }

      if (!_videoPlayerController!.value.isInitialized) {
        debugPrint(
          'VideoPlayerScreen: VideoPlayerController did not report as initialized after .initialize().',
        );
        throw Exception('VideoPlayerController did not initialize properly.');
      }

      setState(() => _statusKey = 'videoPlayerCreatingPlayer');
      debugPrint(
        'VideoPlayerScreen: VideoPlayerController is initialized (true). Creating ChewieController...',
      );
      // chewie controller to provide UI controls for the video player
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade700,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        showControls: true,
        errorBuilder: (context, errorMessage) {
          debugPrint('Chewie errorBuilder caught: $errorMessage');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                Text(
                  'couldNotPlayVideo'.trParams({'errorMessage': errorMessage}),
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      debugPrint(
        'VideoPlayerScreen: ChewieController created. Player should be ready.',
      );
      await FirebaseAnalytics.instance.logEvent(
      name: 'play_video',
      parameters: <String, dynamic>{
        'video_url': widget.videoUrl,
      },
    );
      _fadeController.forward();

      setState(() {
        _isLoading = false;
        _statusKey = 'videoPlayerReady';
      });
    } catch (e) {
      debugPrint("VideoPlayerScreen: Error during _initializePlayer: $e");
      setState(() {
        _isLoading = false;

        _statusKey = 'couldNotPlayVideo'.trParams({
          'errorMessage': e.toString(),
        });
      });

      CustomSnackbar.showErrorCustomSnackbar(
        title: 'playbackError'.tr,
        message: _statusKey,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 16, 0, 61),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
              // Shows an interstitial ad when the user navigates back.
              locator<AdService>().showInterstitialAd();
            },
          ),
          title: const Icon(Icons.play_arrow, color: Colors.white),
          toolbarHeight: 40,
          backgroundColor: const Color.fromARGB(255, 145, 0, 0),
          centerTitle: true,
        ),
        body: Center(
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _fadeController,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: const CircularProgressIndicator(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Text(
                            _statusKey.tr,
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
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child:
                      _chewieController != null &&
                          _videoPlayerController != null &&
                          _videoPlayerController!.value.isInitialized
                      ? Hero(
                          tag: 'video-thumbnail-${widget.videoUrl}',
                          child: Chewie(controller: _chewieController!),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning_amber,
                              color: Colors.orange,
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _statusKey.contains('Error')
                                  ? _statusKey
                                  : 'playbackCouldNotBeStarted'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    debugPrint('VideoPlayerScreen: Disposing controllers.');
    _fadeController.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
