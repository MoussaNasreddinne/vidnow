import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/service_locator.dart'; // Import the locator

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String _initializationStatus = 'Initializing...';
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _initializationStatus = 'Parsing URL...';
    debugPrint('VideoPlayerScreen: _initializePlayer called. URL: "${widget.videoUrl}"');
    try {
      String cleanUrl = widget.videoUrl.replaceAll('"', '').trim();
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(cleanUrl));

      _initializationStatus = 'Loading video...';
      debugPrint('VideoPlayerScreen: Attempting to initialize VideoPlayerController...');

      await _videoPlayerController!.initialize();

      debugPrint('VideoPlayerScreen: VideoPlayerController.initialize() completed.');

      if (_videoPlayerController!.value.hasError) {
        final error = _videoPlayerController!.value.errorDescription;
        debugPrint('VideoPlayerScreen: VideoPlayerController has error: $error');
        throw Exception('Video player error: $error');
      }

      if (!_videoPlayerController!.value.isInitialized) {
        debugPrint('VideoPlayerScreen: VideoPlayerController did not report as initialized after .initialize().');
        throw Exception('VideoPlayerController did not initialize properly.');
      }

      _initializationStatus = 'Creating player...';
      debugPrint('VideoPlayerScreen: VideoPlayerController is initialized (true). Creating ChewieController...');
      
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
                  'Could not play video: $errorMessage',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      debugPrint('VideoPlayerScreen: ChewieController created. Player should be ready.');
      
      _fadeController.forward();
      setState(() {
        _isLoading = false;
        _initializationStatus = 'Ready';
      });
    } catch (e) {
      debugPrint("VideoPlayerScreen: Error during _initializePlayer: $e");
      setState(() {
        _isLoading = false;
        _initializationStatus = 'Error: ${e.toString()}';
      });
      Get.snackbar(
        'Playback Error',
        'Could not load video. Details: ${e.toString().split(':')[0]}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
                            _initializationStatus,
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
                  child: _chewieController != null &&
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
                              _initializationStatus.contains('Error')
                                  ? _initializationStatus
                                  : 'Video playback could not be started.\nDouble-check the video URL or network.',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
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