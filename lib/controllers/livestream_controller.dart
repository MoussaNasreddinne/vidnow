import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/video.dart'; 
import 'package:flutter/material.dart';

class LivestreamController extends GetxController {
  var isLoading = true.obs;
  final RxList<Video> liveChannels = <Video>[].obs; 
  final VideoApiService _apiService = VideoApiService();

  @override
  void onInit() {
    super.onInit();
    fetchLiveChannels();
  }

  Future<void> fetchLiveChannels() async {
    try {
      isLoading(true);
      final List<Video> fetchedChannels = await _apiService.fetchLiveChannels();
      liveChannels.assignAll(fetchedChannels);
      debugPrint('LivestreamController: Fetched ${fetchedChannels.length} live channels.');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load live channels: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('LivestreamController: Error fetching live channels: $e');
      liveChannels.clear();
    } finally {
      isLoading(false);
    }
  }
}