import 'package:get/get.dart';
import 'package:test1/models/video.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/service_locator.dart';

class FavoritesController extends GetxController {
  final FavoriteService _favoriteService = locator<FavoriteService>();

  RxList<Video> get favoriteVideos => _favoriteService.favoriteVideos;

 Future<void> removeFavorite(Video video) async {
    await _favoriteService.removeFavorite(video);
  }
}