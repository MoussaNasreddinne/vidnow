import 'dart:convert';
import 'package:flutter/material.dart'; 
import 'package:test1/video.dart';
import 'package:http/http.dart' as http;

class VideoApiService {
  static const String _baseUrl = "https://d2p4ou0is754xb.cloudfront.net";

  Future<List<Video>> fetchVideos() async {
    final response = await http.get(Uri.parse('$_baseUrl/av_getmobibasevideos?language=en'));

    if (response.statusCode == 200) {
      

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      
      if (responseData['Content'] is List && responseData['Content'].isNotEmpty) {
        final List<dynamic> outerContent = responseData['Content'];
        List<Video> allVideos = [];

        for (var item in outerContent) {
          if (item['Videos'] is List) {
            for (var videoItem in item['Videos']) {
              if (videoItem['Content'] is List) {
                
                for (var contentDetail in videoItem['Content']) {
                  allVideos.add(Video.fromJson(contentDetail));
                }
              }
            }
          }
        }
        return allVideos;
      } else {
        debugPrint('API Response does not contain expected "Content" or "Videos" structure.');
        return []; 
      }
    } else {
      debugPrint('Failed to load videos: Status Code ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }

  Future<String> getStreamUrl(String videoId) async {
    final response = await http.get(Uri.parse('$_baseUrl/av_getstreamvideo?id=$videoId'));
    if (response.statusCode == 200) {
      debugPrint('Raw API Response for stream URL ($videoId): ${response.body}');
      return response.body;
    } else {
      debugPrint('Failed to load stream URL: Status Code ${response.statusCode}, Body: ${response.body}');
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
            
            return Video(
              id: json['ChannelId']?.toString() ?? '', 
              title: json['ChannelName'] ?? 'Unknown Channel',
              thumbnailUrl: json['ChannelThumbnail'] ?? 'https://placehold.co/400x225/333333/FFFFFF?text=Live',
              streamUrl: json['ChannelURL']?.replaceAll('"', '').trim() ?? '', 
              description: json['ChannelDescription'] ?? '',
              isPremium: false, 
            );
          }).toList();
        } else {
          debugPrint('API Response for live channels does not contain expected "Channels" structure.');
          return [];
        }
      } else {
        debugPrint('Failed to load live channels: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load live channels: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching live channels: $e');
      throw Exception('Error fetching live channels: $e');
    }
  }
}
