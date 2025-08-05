import 'package:test1/models/video.dart';

class Category {
  final int id;
  final String name;
  final List<Video> videos;

  Category({required this.id, required this.name, required this.videos});


  // creates a category instance from a json map
  factory Category.fromJson(Map<String, dynamic> json) {
    final videosData = json['Content'] as List<dynamic>? ?? [];
    final videos = videosData
        .map((videoJson) => Video.fromJson(videoJson as Map<String, dynamic>))
        .toList();

    return Category(
      id: json['ID'],
      name: json['CategoryNameAr'] ?? 'Unnamed Category',
      videos: videos,
    );
  }
}
