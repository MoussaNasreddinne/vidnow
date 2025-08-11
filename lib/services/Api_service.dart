import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:test1/models/category.dart';
import 'package:test1/models/video.dart';
import 'package:http/http.dart' as http;
import 'package:test1/screens/videostream.dart';
import 'package:test1/widgets/snackbar.dart';
import 'package:get/get.dart';

class VideoApiService {
  final String _baseUrl;

  VideoApiService({required String baseUrl}) : _baseUrl = baseUrl;

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
      return [];
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  }

  Future<List<Video>> fetchAllVideos() async {
    final categories = await fetchCategories();
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
              'isPremium': 'false',
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
  Future<void> playVideo(Video video) async {
    String finalVideoUrl = video.streamUrl ?? '';

   
    if (finalVideoUrl.isEmpty) {
      
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.red)),
        barrierDismissible: false,
      );

      try {
        finalVideoUrl = await getStreamUrl(video.id);
        Get.back(); 
      } catch (e) {
        Get.back(); 
        CustomSnackbar.showErrorCustomSnackbar(
          title: 'error'.tr,
          message: 'failedToGetVideoStream'
              .trParams({'error': e.toString().split(':')[0]}),
        );
        return; 
      }
    }
    Get.to(() => VideoPlayerScreen(videoUrl: finalVideoUrl));
  }
}