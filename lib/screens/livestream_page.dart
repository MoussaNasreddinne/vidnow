import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/livestream_controller.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/widgets/vidnow_appbar.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/widgets/loading_indicator.dart';
import 'package:test1/screens/videostream.dart';

class LivestreamPage extends StatelessWidget {
  const LivestreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final LivestreamController livestreamController = Get.put(LivestreamController());
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: VidNowAppBar(), 
        body: Obx(() { // rebuilds the body based on the livestream controller's state
          if (livestreamController.isLoading.value) {
            return const LoadingIndicator();
          } else if (livestreamController.liveChannels.isEmpty) {
            return Center(
              child: Text(
                'noLiveChannels'.tr, 
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 145, 0, 0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        " ${'liveChannels'.tr} ", 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: livestreamController.liveChannels.length,
                      itemBuilder: (context, index) {
                        final liveChannel = livestreamController.liveChannels[index];
                        return VideoCard(
                          recommendation: liveChannel, 
                          onTap: () {
                            if (liveChannel.streamUrl != null && liveChannel.streamUrl!.isNotEmpty) {
                              Get.to(() => VideoPlayerScreen(videoUrl: liveChannel.streamUrl!));
                            } else {
                              Get.snackbar(
                                'error'.tr, // Changed
                                'liveStreamNotAvailable'.tr, // Changed
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}