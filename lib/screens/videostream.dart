// lib/screens/videostream.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/controllers/comments_controller.dart';
import 'package:test1/controllers/video_stream_controller.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/widgets/comment_widget.dart';
import 'package:test1/widgets/gradient_background.dart'; 
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
    final theme = Theme.of(context);
    final String controllerTag = videoUrl;
    final VideoStreamController controller = Get.put(
      VideoStreamController(video: video, videoUrl: videoUrl),
      tag: controllerTag,
    );
    final CommentsController commentsController = Get.put(
      CommentsController(
        videoId: video.id,
        videoTitle: video.title,
        thumbnailUrl: video.thumbnailUrl,
      ),
      tag: controllerTag,
    );

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
              locator<AdService>().showInterstitialAd();
            },
          ),
          title: Text(
            video.title,
            
          ),
          toolbarHeight: 40,
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
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tilePadding: const EdgeInsets.symmetric(vertical: 8.0),
                      childrenPadding: const EdgeInsets.only(
                          bottom: 16, left: 16, right: 16),
                      initiallyExpanded: false,
                      // Remove hardcoded icon colors to use theme defaults
                      children: [
                        Text(
                          video.description,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                    const Divider(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Comments',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    // ... The rest of the comments section UI remains the same
                    Obx(() {
                      final replyingTo =
                          commentsController.replyingToUsername.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (replyingTo.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  Text("Replying to $replyingTo"),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: commentsController.cancelReplying,
                                  )
                                ],
                              ),
                            ),
                          TextField(
                            controller: commentsController.textController,
                            decoration: InputDecoration(
                              labelText: 'Add a comment...',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send,
                                    color: theme.primaryColor),
                                onPressed: commentsController.postComment,
                              ),
                            ),
                            minLines: 1,
                            maxLines: 4,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16.0),
                    Obx(() => ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: commentsController.nestedComments
                              .map((comment) => CommentWidget(
                                    comment: comment,
                                    controller: commentsController,
                                    replies: commentsController.replies,
                                  ))
                              .toList(),
                        )),
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