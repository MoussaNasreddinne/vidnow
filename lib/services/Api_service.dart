import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test1/models/category.dart'; // Import the new Category model
import 'package:test1/models/video.dart';
import 'package:http/http.dart' as http;

class VideoApiService {
  static const String _baseUrl = "https://d2p4ou0is754xb.cloudfront.net";

  // This method now fetches and parses the data into a list of Categories.
  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/av_getmobibasevideos?language=en'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

     
      if (responseData['Content'] is List &&
          (responseData['Content'] as List).isNotEmpty) {
        final List<dynamic> outerContent = responseData['Content'];
        if (outerContent.first['Videos'] is List) {
          final List<dynamic> categoriesJson = outerContent.first['Videos'];
          return categoriesJson
              .map((categoryJson) =>
                  Category.fromJson(categoryJson as Map<String, dynamic>))
              .toList();
        }
      }
      // Return an empty list if the structure is not as expected
      return [];
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  // A new helper method to get a flat list of all videos.
  // This is useful for the favorites feature, so it doesn't have to re-fetch everything.
  Future<List<Video>> fetchAllVideos() async {
    final categories = await fetchCategories();
    // Flatten the list of lists of videos into a single list
    return categories.expand((category) => category.videos).toList();
  }

  Future<String> getStreamUrl(String videoId) async {
    final response =
        await http.get(Uri.parse('$_baseUrl/av_getstreamvideo?id=$videoId'));
    if (response.statusCode == 200) {
      debugPrint('Raw API Response for stream URL ($videoId): ${response.body}');
      return response.body;
    } else {
      debugPrint(
          'Failed to load stream URL: Status Code ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load stream URL');
    }
  }

  Future<List<Video>> fetchLiveChannels() async {
    final uri = Uri.parse('$_baseUrl/av_tvchannels');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        debugPrint('Raw API Response for /av_tvchannels: ${response.body}');
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['Channels'] is List) {
          List<dynamic> jsonList = responseData['Channels'];
          return jsonList.map((json) {
            return Video.fromJson({
              'ID': json['ChannelId']?.toString() ?? '',
              'Title': json['ChannelName'] ?? 'Unknown Channel',
              'Thumbnail': json['ChannelThumbnail'] ??
                  'https://placehold.co/400x225/333333/FFFFFF?text=Live',
              'StreamURL': json['ChannelURL']?.replaceAll('"', '').trim() ?? '',
              'Description': json['ChannelDescription'] ?? '',
              'isPremium': 'false', // Assuming live channels are not premium
            });
          }).toList();
        } else {
          debugPrint(
              'API Response for live channels does not contain expected "Channels" structure.');
          return [];
        }
      } else {
        debugPrint(
            'Failed to load live channels: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load live channels: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching live channels: $e');
      throw Exception('Error fetching live channels: $e');
    }
  }
}