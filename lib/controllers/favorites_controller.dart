import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/models/video.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/service_locator.dart';

class FavoritesController extends GetxController {
  final FavoriteService _favoriteService = locator<FavoriteService>();
  final VideoApiService _apiService = locator<VideoApiService>();

  final RxList<Video> favoriteVideos = <Video>[].obs;
  final RxBool isLoadingFavorites = true.obs;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  FavoritesController() {
    _loadFavoriteVideos();
    // This listener efficiently handles UI updates when favorites change.
    ever(_favoriteService.favoriteVideoIds, (_) => _handleFavoritesChange());
  }

  Future<void> _loadFavoriteVideos() async {
    isLoadingFavorites(true);
    favoriteVideos.clear();

    final List<String> favIds = _favoriteService.getFavoriteVideoIdsList();
    if (favIds.isEmpty) {
      isLoadingFavorites(false);
      return;
    }

    try {
      // Use the more efficient fetchAllVideos() method
      final List<Video> allVideos = await _apiService.fetchAllVideos();
      favoriteVideos.assignAll(
          allVideos.where((video) => favIds.contains(video.id)).toList());
    } finally {
      isLoadingFavorites(false);
    }
  }

  // This logic for handling changes can remain largely the same,
  // but it will also benefit from the more efficient video fetching.
  void _handleFavoritesChange() {
    final currentIds = favoriteVideos.map((v) => v.id).toList();
    final newIds = _favoriteService.getFavoriteVideoIdsList();

    // Handle removals
    for (int i = favoriteVideos.length - 1; i >= 0; i--) {
      if (!newIds.contains(favoriteVideos[i].id)) {
        final removedVideo = favoriteVideos.removeAt(i);
        listKey.currentState?.removeItem(
          i,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: VideoCard(recommendation: removedVideo, onTap: () {}),
          ),
        );
      }
    }

    // Handle additions
    if (favoriteVideos.isNotEmpty) {
      _apiService.fetchAllVideos().then((allVideos) {
        for (final id in newIds) {
          if (!currentIds.contains(id)) {
            final videoToAdd = allVideos.firstWhere((v) => v.id == id);
            favoriteVideos.add(videoToAdd);
            listKey.currentState?.insertItem(favoriteVideos.length - 1);
          }
        }
      });
    } else {
      _loadFavoriteVideos(); // Reload if empty
    }
  }
}