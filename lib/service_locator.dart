import 'package:get_it/get_it.dart';
import 'package:test1/controllers/ad_controller.dart';
import 'package:test1/controllers/button_controller.dart';
import 'package:test1/controllers/favorites_controller.dart';
import 'package:test1/controllers/livestream_controller.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/controllers/rec_controller.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/controllers/theme_controller.dart';
import 'package:test1/controllers/language_controller.dart';


GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Services
  locator.registerLazySingleton(() => VideoApiService());
  locator.registerLazySingleton(() => AdService());

  // initialized first since it needs shared preferences
  locator.registerSingletonAsync<FavoriteService>(() async {
    final favoriteService = FavoriteService();
    await favoriteService.init(); // Call the new initializer
    return favoriteService;
  });

  // Wait for FavoriteService to be ready before registering controllers that depend on it
  await locator.isReady<FavoriteService>();

  // Controllers 
  locator.registerLazySingleton(() => AdController());
  locator.registerLazySingleton(() => ButtonController());
  locator.registerLazySingleton(() => FavoritesController());
  locator.registerLazySingleton(() => LivestreamController());
  locator.registerLazySingleton(() => NavController());
  locator.registerLazySingleton(() => RecommendationController());
  locator.registerLazySingleton(() => ThemeController());
  locator.registerLazySingleton(() => LanguageController());
  
}