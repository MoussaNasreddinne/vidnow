import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart'; 
import 'package:test1/video.dart';
import 'package:test1/service_locator.dart';

class RecommendationController extends GetxController {
  final VideoApiService _apiService = locator<VideoApiService>();
  
  var selectedCategoryIndex = 0.obs;
  var isLoading = true.obs;
  final RxList<Video> _allVideos = <Video>[].obs;
  final RxList<Video> _currentFilteredVideos = <Video>[].obs;
  final List<String> _staticCategoryNames = ['All', 'Action', 'Comedy', 'Drama'];

  RecommendationController() {
    fetchAllVideosAndPopulateCategories();
    ever(selectedCategoryIndex, (_) => _applyCategoryFilter());
  }

  Future<void> fetchAllVideosAndPopulateCategories() async {
    try {
      isLoading(true);
      List<Video> fetchedVideos = await _apiService.fetchVideos();
      _allVideos.assignAll(fetchedVideos);
      _currentFilteredVideos.assignAll(fetchedVideos); 
    } catch (e) {
      Get.snackbar('Error', 'Failed to load videos: $e', snackPosition: SnackPosition.BOTTOM);
      print('Error fetching all videos: $e');
      _allVideos.clear();
      _currentFilteredVideos.clear();
    } finally {
      isLoading(false);
    }
  }
  
  void _applyCategoryFilter() {
    if (_allVideos.isEmpty) return; 

    String selectedCategory = _staticCategoryNames[selectedCategoryIndex.value];
    if (selectedCategory == 'All') {
      _currentFilteredVideos.assignAll(_allVideos);
    } else {
      _currentFilteredVideos.assignAll(_allVideos.where((video) =>
          video.title.toLowerCase().contains(selectedCategory.toLowerCase())
      ).toList());
      if (_currentFilteredVideos.isEmpty && selectedCategory != 'All') {
          _currentFilteredVideos.assignAll(_allVideos);
      }
    }
  }

  List<Video> get currentRecommendations {
    return _currentFilteredVideos;
  }

  List<String> get categoryNames {
    return _staticCategoryNames; 
  }
}