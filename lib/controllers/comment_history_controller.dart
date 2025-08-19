import 'package:get/get.dart';
import 'package:test1/models/comment.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/services/comments_service.dart';
import 'package:test1/service_locator.dart';

class CommentHistoryController extends GetxController {
  final CommentsService _commentsService = locator<CommentsService>();
  final VideoApiService _apiService = locator<VideoApiService>();

  var isLoading = true.obs;
  var isNavigating = false.obs;
  final RxList<Comment> userComments = <Comment>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserComments();
  }

  Future<void> fetchUserComments() async {
    try {
      isLoading(true);
      final comments = await _commentsService.getCommentsForUser();
      userComments.assignAll(comments);
    } finally {
      isLoading(false);
    }
  }

  Future<void> navigateToVideo(String videoId) async {
    try {
      isNavigating.value = true;
      final video = await _apiService.fetchVideoById(videoId);
      if (video != null) {
        _apiService.playVideo(video);
      } else {
        Get.snackbar('Error', 'Video not found or is no longer available.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Could not navigate to video.');
    } finally {
      isNavigating.value = false;
    }
  }
}