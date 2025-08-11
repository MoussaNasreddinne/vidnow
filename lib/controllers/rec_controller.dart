// lib/controllers/rec_controller.dart

import 'package:get/get.dart';
import 'package:test1/models/category.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/snackbar.dart';

class RecommendationController extends GetxController {
  final VideoApiService _apiService = locator<VideoApiService>();
  var selectedCategoryIndex = 0.obs;
  var isLoading = true.obs;
  final RxList<Category> _allCategories = <Category>[].obs;

  RecommendationController() {
    fetchCategories();
  }

  
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      List<Category> fetchedCategories = await _apiService.fetchCategories();
      _allCategories.assignAll(fetchedCategories);
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Failed to load videos',
      );
      print('Error fetching categories: $e');
    } finally {
      isLoading(false);
    }
  }

  
  Future<void> refreshCategories() async {
    try {
      List<Category> fetchedCategories = await _apiService.fetchCategories();
      _allCategories.assignAll(fetchedCategories);
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Failed to refresh videos',
      );
    }
  }

  List<String> get categoryNames {
    return ['All', ..._allCategories.map((c) => c.name).toList()];
  }

  List<Video> get currentRecommendations {
    if (isLoading.value || _allCategories.isEmpty) {
      return [];
    }
    if (selectedCategoryIndex.value == 0) {
      return _allCategories.expand((category) => category.videos).toList();
    }
    final categoryIndex = selectedCategoryIndex.value - 1;
    if (categoryIndex >= 0 && categoryIndex < _allCategories.length) {
      return _allCategories[categoryIndex].videos;
    }
    return [];
  }
}