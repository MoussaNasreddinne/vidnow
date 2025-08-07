import 'package:get/get.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/models/video.dart';
import 'package:flutter/material.dart';
import 'package:test1/widgets/snackbar.dart';

class LivestreamController extends GetxController {
  var isLoading = true.obs;
  final RxList<Video> liveChannels = <Video>[].obs;
  final VideoApiService _apiService = VideoApiService(baseUrl: ''); 

  @override
  void onInit() {
    super.onInit();
    fetchLiveChannels();
  }

  // Fetches the list of live channels from the API service.
  Future<void> fetchLiveChannels() async {
    try {
      isLoading(true);
      final List<Video> fetchedChannels = await _apiService.fetchLiveChannels();
      liveChannels.assignAll(fetchedChannels);
      debugPrint(
        'LivestreamController: Fetched ${fetchedChannels.length} live channels.',
      );
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Failed to load live channels',
      );
      debugPrint('LivestreamController: Error fetching live channels: $e');
      liveChannels.clear();
    } finally {
      isLoading(false);
    }
  }
}