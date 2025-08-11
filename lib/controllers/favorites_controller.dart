
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/widgets/video_card.dart';

class FavoritesController extends GetxController {
  final FavoriteService _favoriteService = locator<FavoriteService>();
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

 
  RxList<Video> get favoriteVideos => _favoriteService.favoriteVideos;

  
  void removeItem(int index) {
    
    final video = _favoriteService.favoriteVideos[index];

   
    _favoriteService.removeFavorite(video);

  
    listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildRemovedItem(video, animation),
      duration: const Duration(milliseconds: 400),
    );
  }


  Widget _buildRemovedItem(Video video, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: VideoCard(
          recommendation: video,
          onTap: () {},
        ),
      ),
    );
  }
}