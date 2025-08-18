import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:test1/services/watch_history_service.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/snackbar.dart';

class WatchHistoryController extends GetxController {
  final WatchHistoryService _watchHistoryService = locator<WatchHistoryService>();

  var isLoading = true.obs;
  final RxList<Video> historyVideos = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading(true);
      final videos = await _watchHistoryService.getWatchHistory();
      historyVideos.assignAll(videos);
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'error'.tr,
        message: 'Could not load your watch history.',
      );
    } finally {
      isLoading(false);
    }
  }
}