import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:flutter/material.dart';
import 'package:test1/widgets/snackbar.dart';

class FavoriteService {
  late SharedPreferences _prefs;
  final String _favoritesKey = 'favoriteVideos';

  //set of favorite video ids
  final RxSet<String> favoriteVideoIds = <String>{}.obs;

  //initializes by loading data from the sharedpreferences
  Future<void> init() async {
    await _initPrefs();
    _loadFavoriteIds();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //list of favorite vid ids from storage
  void _loadFavoriteIds() {
    final String? encodedMap = _prefs.getString(_favoritesKey);
    if (encodedMap != null) {
      final List<dynamic> decodedList = json.decode(encodedMap);
      favoriteVideoIds.assignAll(
        decodedList.map((id) => id.toString()).toSet(),
      );
      debugPrint(
        'FavoriteService: Loaded ${favoriteVideoIds.length} favorite IDs.',
      );
    }
  }

  //saves the current list of favorites ids to storage
  Future<void> _saveFavoriteIds() async {
    final String encodedMap = json.encode(favoriteVideoIds.toList());
    await _prefs.setString(_favoritesKey, encodedMap);
    debugPrint(
      'FavoriteService: Saved ${favoriteVideoIds.length} favorite IDs.',
    );
  }

  bool isFavorite(String videoId) {
    return favoriteVideoIds.contains(videoId);
  }

  // Adds a video to the favorites list and shows a confirmation snackbar.
  Future<void> addFavorite(Video video) async {
    if (!favoriteVideoIds.contains(video.id)) {
      favoriteVideoIds.add(video.id);
      await _saveFavoriteIds();

      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'Favorites',
        message: 'Added "${video.title}" to favorites!',
      );
      debugPrint('FavoriteService: Added video ID: ${video.id}');
    }
  }

  Future<void> removeFavorite(String videoId, String videoTitle) async {
    if (favoriteVideoIds.remove(videoId)) {
      await _saveFavoriteIds();
      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'Favorites',
        message: 'Removed "$videoTitle" to favorites!',
      );
      debugPrint('FavoriteService: Removed video ID: $videoId');
    }
  }

  List<String> getFavoriteVideoIdsList() {
    return favoriteVideoIds.toList();
  }
}
