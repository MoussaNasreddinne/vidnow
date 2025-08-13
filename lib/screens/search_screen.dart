import 'package:flutter/material.dart' hide SearchController; 
import 'package:get/get.dart';
import 'package:test1/controllers/search_controller.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/video_card.dart';
import 'package:test1/widgets/gradient_background.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchController searchController = Get.put(SearchController());
    final VideoApiService apiService = locator<VideoApiService>();
    final theme = Theme.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 0,
          title: TextField(
            autofocus: true,
            onChanged: (value) => searchController.updateSearchQuery(value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search for videos...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
          ),
        ),
        body: Obx(() {
          if (searchController.searchQuery.isEmpty) {
            return const Center(
              child: Text(
                'Start typing to search for videos.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          } else if (searchController.searchResults.isEmpty) {
            return const Center(
              child: Text(
                'No videos found for your search.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: searchController.searchResults.length,
              itemBuilder: (context, index) {
                final video = searchController.searchResults[index];
                return VideoCard(
                  recommendation: video,
                  onTap: () => apiService.playVideo(video),
                );
              },
            );
          }
        }),
      ),
    );
  }
}