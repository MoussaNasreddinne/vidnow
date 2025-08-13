import 'package:get/get.dart';
import 'package:test1/controllers/rec_controller.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';

class SearchController extends GetxController {
  final RecommendationController _recController = locator<RecommendationController>();

  final RxString searchQuery = ''.obs;
  final RxList<Video> searchResults = <Video>[].obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => _performSearch(), time: const Duration(milliseconds: 300));
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void _performSearch() {
    if (searchQuery.value.isEmpty) {
      searchResults.clear();
      return;
    }

    final allVideos = _recController.currentRecommendations;
    final filteredVideos = allVideos.where((video) {
      return video.title.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();

    searchResults.assignAll(filteredVideos);
  }

  @override
  void onClose() {
    searchQuery.value = '';
    searchResults.clear();
    super.onClose();
  }
}