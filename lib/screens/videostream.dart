import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/video_stream_controller.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/widgets/player_widget.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;
  final Video video;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String controllerTag = videoUrl;
    final VideoStreamController controller = Get.put(
      VideoStreamController(video: video, videoUrl: videoUrl),
      tag: controllerTag,
    );

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
              Get.delete<VideoStreamController>(tag: controllerTag);
              Get.back();
              locator<AdService>().showInterstitialAd();
            },
          ),
          title: Text(
            video.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                overflow: TextOverflow.ellipsis),
          ),
          toolbarHeight: 40,
          backgroundColor: const Color.fromARGB(255, 145, 0, 0),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Obx(() => PlayerWidget(
                      isLoading: controller.isLoading.value,
                      chewieController: controller.chewieController,
                      fadeController: controller.fadeController,
                      fadeAnimation: controller.fadeAnimation,
                      statusKey: controller.statusKey.value,
                      videoId: controller.video.id,
                    )),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      title: Text(
                        video.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontSize: 20),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tilePadding: const EdgeInsets.symmetric(vertical: 8.0),
                      childrenPadding: const EdgeInsets.only(
                          bottom: 16, left: 16, right: 16),
                      initiallyExpanded: false,
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white70,
                      children: [
                        Text(
                          video.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                    const Divider(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Comments',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Center(
                      child: Text(
                        'The comments section will be implemented soon.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}