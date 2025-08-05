import 'package:flutter/material.dart';

class Video {
  final String id;

  final String title;

  final String thumbnailUrl;

  final Duration? duration;

  final String description;

  final bool isPremium;

  final String? categoryName;

  String? streamUrl;

  // constructor for empty video
  factory Video.empty() {
    return Video(
      id: '',
      title: '',
      thumbnailUrl: '',
      description: '',
      isPremium: false,
    );
  }

  Video({
    required this.id,

    required this.title,

    required this.thumbnailUrl,

    this.duration,

    required this.description,

    required this.isPremium,

    this.streamUrl,

    this.categoryName,
  });

  // constructor to create a video instance from a json map
  factory Video.fromJson(Map<String, dynamic> json, {String? category}) {
    Duration? parsedDuration;

    if (json['Duration'] != null) {
      if (json['Duration'] is String) {
        parsedDuration = Duration(seconds: int.tryParse(json['Duration']) ?? 0);
      } else if (json['Duration'] is int) {
        parsedDuration = Duration(seconds: json['Duration']);
      }
    }

    String? directStreamUrl;

    if (json['StreamURL'] != null) {
      directStreamUrl = json['StreamURL'].replaceAll('"', '').trim();
    } else if (json['DirectURL'] != null) {
      directStreamUrl = json['DirectURL'].replaceAll('"', '').trim();
    }

    if (directStreamUrl?.isEmpty ?? true) {
      directStreamUrl = null;
    }

    return Video(
      id: json['ID']?.toString() ?? UniqueKey().toString(),

      title: json['Title'] ?? 'No Title',

      thumbnailUrl:
          json['Thumbnail'] ??
          'https://via.placeholder.com/150x85?text=No+Image',

      duration: parsedDuration,

      description: json['Description'] ?? 'No description available.',

      isPremium: json['isPremium']?.toLowerCase() == 'true' ?? false,

      streamUrl: directStreamUrl,

      categoryName: category,
    );
  }
}
