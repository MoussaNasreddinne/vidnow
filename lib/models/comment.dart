import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String videoId;
  final String? videoTitle;
  final String? thumbnailUrl;
  final String userId;
  final String username;
  final String? userPhotoUrl;
  final String text;
  final Timestamp timestamp;
  final Timestamp? lastEdited; 
  final String? parentId; 
  final int likesCount;
  final List<String> likedBy; 

  Comment({
    required this.id,
    required this.videoId,
    this.videoTitle,
    this.thumbnailUrl, 
    required this.userId,
    required this.username,
    this.userPhotoUrl,
    required this.text,
    required this.timestamp,
    this.lastEdited,
    this.parentId,
    required this.likesCount,
    required this.likedBy,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      videoId: data['videoId'] ?? '',
      videoTitle: data['videoTitle'],
      thumbnailUrl: data['thumbnailUrl'],
      userId: data['userId'] ?? '',
      username: data['username'] ?? 'Anonymous',
      userPhotoUrl: data['userPhotoUrl'],
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      lastEdited: data['lastEdited'],
      parentId: data['parentId'],
      likesCount: data['likesCount'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
    );
  }
}