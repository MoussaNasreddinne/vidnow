import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:flutter/material.dart';
import 'package:test1/widgets/snackbar.dart';

class FavoriteService {
  late SharedPreferences _prefs;
  final String _favoritesKey = 'favoriteVideos_v2';
  final RxList<Video> favoriteVideos = <Video>[].obs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavorites();
  }

  void _loadFavorites() {
    final String? encodedList = _prefs.getString(_favoritesKey);
    if (encodedList != null) {
      final List<dynamic> decodedList = json.decode(encodedList);
      favoriteVideos.assignAll(
        decodedList.map((item) => Video.fromJson(item as Map<String, dynamic>)).toList(),
      );
      debugPrint('FavoriteService: Loaded ${favoriteVideos.length} favorite videos.');
    }
  }

  Future<void> _saveFavorites() async {
    final List<Map<String, dynamic>> encodedList =
        favoriteVideos.map((video) => video.toJson()).toList();
    await _prefs.setString(_favoritesKey, json.encode(encodedList));
    debugPrint('FavoriteService: Saved ${favoriteVideos.length} favorite videos.');
  }

  bool isFavorite(String videoId) {
    return favoriteVideos.any((video) => video.id == videoId);
  }

  Future<void> addFavorite(Video video) async {
    if (!isFavorite(video.id)) {
      favoriteVideos.insert(0, video); 
      await _saveFavorites();
      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'favorites'.tr,
        message: 'addedToFavorites'.trParams({'videoTitle': video.title}),
      );
      debugPrint('FavoriteService: Added video: ${video.title}');
    }
  }

  Future<void> removeFavorite(Video video) async {
    int index = favoriteVideos.indexWhere((v) => v.id == video.id);
    if (index != -1) {
      favoriteVideos.removeAt(index);
      await _saveFavorites();
      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'favorites'.tr,
        message: 'removedFromFavorites'.trParams({'videoTitle': video.title}),
      );
      debugPrint('FavoriteService: Removed video: ${video.title}');
    }
  }
}