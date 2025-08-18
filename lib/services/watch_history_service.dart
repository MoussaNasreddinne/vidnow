import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/models/video.dart';
import 'package:test1/service_locator.dart';

class WatchHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController get _authController => locator<AuthController>();

  Future<void> addVideoToHistory(Video video) async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return;

    try {
      var videoData = video.toJson();
      videoData['watchedAt'] = FieldValue.serverTimestamp(); 

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .doc(video.id)
          .set(videoData);
      debugPrint('WatchHistoryService: Added video to history: ${video.title}');
    } catch (e) {
      debugPrint('WatchHistoryService: Error adding video to history: $e');
    }
  }

  Future<List<Video>> getWatchHistory() async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watch_history')
          .orderBy('watchedAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Video.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('WatchHistoryService: Error fetching watch history: $e');
      return [];
    }
  }
}