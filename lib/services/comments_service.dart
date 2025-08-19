import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/models/comment.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/services/auth_service.dart';

class CommentsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = locator<AuthController>();
  final AuthService _authService = locator<AuthService>();

  // Fetches a real-time stream of comments for a specific video
  Stream<List<Comment>> getCommentsForVideo(String videoId) {
    return _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList(),
        );
  }

  // Fetches all comments made by a specific user for the "Comment History" screen
  Future<List<Comment>> getCommentsForUser() async {
    final userId = _authController.user.value?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
        .collectionGroup('comments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
  }

  // Adds a new comment or a reply to a video
  Future<void> addComment({
    required String videoId,
    required String videoTitle,
    required String thumbnailUrl,
    required String text,
    String? parentId,
  }) async {
    final user = _authController.user.value;
    if (user == null) {
      throw Exception("You must be logged in to comment.");
    }

    // Fetch the user's profile to get the latest username
    final userProfile = await _authService.getUserProfile(user.uid);
    final username = userProfile?['username'] ?? 'Anonymous';

    final commentData = {
      'videoId': videoId,
      'videoTitle': videoTitle,
      'thumbnailUrl': thumbnailUrl,
      'text': text,
      'userId': user.uid,
      'username': username,
      'userPhotoUrl': user.photoURL ?? userProfile?['photoUrl'],
      'timestamp': FieldValue.serverTimestamp(),
      'parentId': parentId,
    };

    await _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .add(commentData);
  }

  Future<void> updateComment({
    required String videoId,
    required String commentId,
    required String newText,
  }) async {
    await _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId)
        .update({'text': newText, 'lastEdited': FieldValue.serverTimestamp()});
  }

  Future<void> deleteComment({
    required String videoId,
    required String commentId,
  }) async {
    await _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }
  Future<void> toggleCommentLike({
    required String videoId,
    required String commentId,
  }) async {
    final userId = _authController.user.value?.uid;
    if (userId == null) {
      throw Exception("You must be logged in to like a comment.");
    }

    final commentRef = _firestore
        .collection('videos')
        .doc(videoId)
        .collection('comments')
        .doc(commentId);

    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(commentRef);
      if (!snapshot.exists) {
        throw Exception("Comment does not exist!");
      }

      final List<String> likedBy = List<String>.from(snapshot.data()?['likedBy'] ?? []);

      if (likedBy.contains(userId)) {
        // User is unliking the comment
        transaction.update(commentRef, {
          'likesCount': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId])
        });
      } else {
        // User is liking the comment
        transaction.update(commentRef, {
          'likesCount': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId])
        });
      }
    });
  }
}
