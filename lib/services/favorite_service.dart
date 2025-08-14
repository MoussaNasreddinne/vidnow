import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/models/video.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/controllers/auth_controller.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AuthController get _authController => locator<AuthController>();

  final RxList<Video> favoriteVideos = <Video>[].obs;
  StreamSubscription? _favoritesSubscription;

  Future<void> init() async {
     _authController.user.listen((firebaseUser) {
      if (firebaseUser != null) {
        _listenToFavorites(firebaseUser.uid);
      } else {
        favoriteVideos.clear();
        _favoritesSubscription?.cancel();
      }
    });
  }

 void _listenToFavorites(String userId) {
    _favoritesSubscription?.cancel();

    final favoritesCollection = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('createdAt', descending: true);

    _favoritesSubscription = favoritesCollection.snapshots().listen((snapshot) {
      final videos = snapshot.docs
          .map((doc) => Video.fromJson(doc.data()))
          .toList();
      favoriteVideos.assignAll(videos);
      debugPrint('FavoriteService: Synced ${videos.length} favorites from Firestore.');
    }, onError: (error) {
      debugPrint('FavoriteService: Error listening to favorites: $error');
      favoriteVideos.clear();
    });
  }

 bool isFavorite(String videoId) {
    return favoriteVideos.any((video) => video.id == videoId);
  }

  Future<void> addFavorite(Video video) async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return; 

    if (!isFavorite(video.id)) {
      try {
        var videoData = video.toJson();
        videoData['createdAt'] = FieldValue.serverTimestamp();

        await _firestore
            .collection('users')
            .doc(userId)
            .collection('favorites')
            .doc(video.id)
            .set(videoData);

        CustomSnackbar.showSuccessCustomSnackbar(
          title: 'favorites'.tr,
          message: 'addedToFavorites'.trParams({'videoTitle': video.title}),
        );
        debugPrint('FavoriteService: Added video to Firestore: ${video.title}');
      } catch (e) {
        debugPrint('FavoriteService: Error adding favorite: $e');
        CustomSnackbar.showErrorCustomSnackbar(
          title: 'error'.tr,
          message: 'Could not add to favorites.',
        );
      }
    }
  }

  Future<void> removeFavorite(Video video) async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return; 

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(video.id)
          .delete();

      CustomSnackbar.showSuccessCustomSnackbar(
        title: 'favorites'.tr,
        message: 'removedFromFavorites'.trParams({'videoTitle': video.title}),
      );
      debugPrint('FavoriteService: Removed video from Firestore: ${video.title}');
    } catch (e) {
      debugPrint('FavoriteService: Error removing favorite: $e');
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'error'.tr,
        message: 'Could not remove from favorites.',
      );
    }
  }
}