
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/models/comment.dart';
import 'package:test1/services/comments_service.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/snackbar.dart';

class CommentsController extends GetxController {
  final String videoId;
  final String videoTitle;
  final String thumbnailUrl;
  final CommentsService _commentsService = locator<CommentsService>();

  final RxList<Comment> _comments = <Comment>[].obs;
  final TextEditingController textController = TextEditingController();
  final Rx<String?> replyingToCommentId = Rx<String?>(null);
  final Rx<String> replyingToUsername = ''.obs;

  late final StreamSubscription<List<Comment>> _commentSubscription;

  CommentsController({
    required this.videoId,
    required this.videoTitle,
    required this.thumbnailUrl,
  });
  
  List<Comment> get nestedComments => _buildNestedComments();

  @override
  void onInit() {
    super.onInit();
    _commentSubscription =
        _commentsService.getCommentsForVideo(videoId).listen((comments) {
      _comments.assignAll(comments);
    });
  }
  
  List<Comment> _buildNestedComments() {
    Map<String, List<Comment>> repliesMap = {};
    List<Comment> topLevelComments = [];

    for (var comment in _comments) {
      if (comment.parentId != null) {
        repliesMap.putIfAbsent(comment.parentId!, () => []).add(comment);
      } else {
        topLevelComments.add(comment);
      }
    }
    return topLevelComments;
  }
  
  Map<String, List<Comment>> get replies {
     Map<String, List<Comment>> repliesMap = {};
     for (var comment in _comments) {
      if (comment.parentId != null) {
        repliesMap.putIfAbsent(comment.parentId!, () => []).add(comment);
      }
    }
    return repliesMap;
  }

  void startReplying(String commentId, String username) {
    replyingToCommentId.value = commentId;
    replyingToUsername.value = username;
  }

  void cancelReplying() {
    replyingToCommentId.value = null;
    replyingToUsername.value = '';
  }

  Future<void> postComment() async {
    if (textController.text.trim().isEmpty) return;

    try {
      await _commentsService.addComment(
        videoId: videoId,
        videoTitle: videoTitle,
        thumbnailUrl: thumbnailUrl,
        text: textController.text.trim(),
        parentId: replyingToCommentId.value,
      );
      textController.clear();
      cancelReplying();
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: "Comment Error",
        message: e.toString(),
      );
    }
  }
  Future<void> editComment(String commentId, String newText) async {
    try {
      await _commentsService.updateComment(
        videoId: videoId,
        commentId: commentId,
        newText: newText.trim(),
      );
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Failed to update comment.',
      );
    }
  }
   Future<void> likeComment(String commentId) async {
    try {
      await _commentsService.toggleCommentLike(
        videoId: videoId,
        commentId: commentId,
      );
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: e.toString(),
      );
    }
  }

  // New method to handle deleting a comment
  Future<void> deleteComment(String commentId) async {
    try {
      await _commentsService.deleteComment(
        videoId: videoId,
        commentId: commentId,
      );
    } catch (e) {
      CustomSnackbar.showErrorCustomSnackbar(
        title: 'Error',
        message: 'Failed to delete comment.',
      );
    }
  }

  @override
  void onClose() {
    _commentSubscription.cancel();
    textController.dispose();
    super.onClose();
  }
}