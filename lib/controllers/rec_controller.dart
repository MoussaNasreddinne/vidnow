import 'package:get/get.dart';
import 'package:test1/models/category.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';

class RecommendationController extends GetxController {
  final VideoApiService _apiService = locator<VideoApiService>();

  var selectedCategoryIndex = 0.obs;
  var isLoading = true.obs;
  final RxList<Category> _allCategories = <Category>[].obs;

  RecommendationController() {
    fetchCategories();
  }
  // Fetches video categories from the API.
  void fetchCategories() async {
    try {
      isLoading(true);
      List<Category> fetchedCategories = await _apiService.fetchCategories();
      _allCategories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load videos: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error fetching categories: $e');
    } finally {
      isLoading(false);
    }
  }

  // Computed property for category names
  List<String> get categoryNames {
    // "All" as the first category
    return ['All', ..._allCategories.map((c) => c.name).toList()];
  }

  // Computed property for the currently displayed videos
  List<Video> get currentRecommendations {
    if (isLoading.value || _allCategories.isEmpty) {
      return [];
    }
    // If "All" is selected (index 0)
    if (selectedCategoryIndex.value == 0) {
      // Return a single flat list of all videos from all categories
      return _allCategories.expand((category) => category.videos).toList();
    }
    // Otherwise, return videos for the selected category
    final categoryIndex = selectedCategoryIndex.value - 1;
    if (categoryIndex >= 0 && categoryIndex < _allCategories.length) {
      return _allCategories[categoryIndex].videos;
    }
    return [];
  }
}
