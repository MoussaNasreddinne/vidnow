import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:flutter/material.dart';

class FavoriteService {
  late SharedPreferences _prefs;
  final String _favoritesKey = 'favoriteVideos';

  final RxSet<String> favoriteVideoIds = <String>{}.obs;

  // New initializer method to be called from the service locator
  Future<void> init() async {
    await _initPrefs();
    _loadFavoriteIds();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _loadFavoriteIds() {
    final String? encodedMap = _prefs.getString(_favoritesKey);
    if (encodedMap != null) {
      final List<dynamic> decodedList = json.decode(encodedMap);
      favoriteVideoIds.assignAll(decodedList.map((id) => id.toString()).toSet());
      debugPrint('FavoriteService: Loaded ${favoriteVideoIds.length} favorite IDs.');
    }
  }

  Future<void> _saveFavoriteIds() async {
    final String encodedMap = json.encode(favoriteVideoIds.toList());
    await _prefs.setString(_favoritesKey, encodedMap);
    debugPrint('FavoriteService: Saved ${favoriteVideoIds.length} favorite IDs.');
  }

  bool isFavorite(String videoId) {
    return favoriteVideoIds.contains(videoId);
  }

  Future<void> addFavorite(Video video) async {
    if (!favoriteVideoIds.contains(video.id)) {
      favoriteVideoIds.add(video.id);
      await _saveFavoriteIds();
      Get.snackbar(
        'Favorites',
        'Added "${video.title}" to favorites!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      debugPrint('FavoriteService: Added video ID: ${video.id}');
    }
  }

  Future<void> removeFavorite(String videoId, String videoTitle) async {
    if (favoriteVideoIds.remove(videoId)) { 
      await _saveFavoriteIds();
      Get.snackbar(
        'Favorites',
        'Removed "${videoTitle}" from favorites!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      debugPrint('FavoriteService: Removed video ID: $videoId');
    }
  }

  List<String> getFavoriteVideoIdsList() {
    return favoriteVideoIds.toList(); 
  }
}