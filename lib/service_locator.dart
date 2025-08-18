import 'package:get_it/get_it.dart';
import 'package:test1/controllers/ad_controller.dart';
import 'package:test1/controllers/button_controller.dart';
import 'package:test1/controllers/edit_profile_controller.dart';
import 'package:test1/controllers/favorites_controller.dart';
import 'package:test1/controllers/livestream_controller.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/controllers/rec_controller.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/services/Api_service.dart';
import 'package:test1/services/favorite_service.dart';
import 'package:test1/controllers/theme_controller.dart';
import 'package:test1/controllers/language_controller.dart';
import 'package:test1/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/controllers/forgot_password_controller.dart';
import 'package:test1/services/remote_config_service.dart';
import 'package:test1/controllers/search_controller.dart';
import 'package:test1/controllers/watch_history_controller.dart';
import 'package:test1/services/watch_history_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  //Firebase - Remote Config
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  locator.registerSingletonAsync<RemoteConfigService>(() => RemoteConfigService.create());
  await locator.isReady<RemoteConfigService>();
  final remoteConfig = locator<RemoteConfigService>();

  //Services 
  locator.registerLazySingleton(() => VideoApiService(baseUrl: remoteConfig.apiBaseUrl));
  locator.registerLazySingleton(() => AdService(interstitialAdUnitId: remoteConfig.interstitialAdUnitId));
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => WatchHistoryService()); 

  //Controllers
  locator.registerLazySingleton(() => AuthController());
  locator.registerLazySingleton(() => AdController(bannerAdUnitId: remoteConfig.bannerAdUnitId));
  locator.registerLazySingleton(() => ThemeController(defaultIsDark: remoteConfig.defaultThemeIsDark));
  locator.registerLazySingleton(() => LanguageController(defaultLanguageCode: remoteConfig.defaultLanguageCode));
  locator.registerLazySingleton(() => ForgotPasswordController());
  locator.registerLazySingleton(() => LoginController());
  locator.registerLazySingleton(() => EditProfileController());
  locator.registerLazySingleton(() => ButtonController());
  locator.registerLazySingleton(() => FavoritesController());
  locator.registerLazySingleton(() => WatchHistoryController());
  locator.registerLazySingleton(() => LivestreamController());
  locator.registerLazySingleton(() => NavController());
  locator.registerLazySingleton(() => RecommendationController());
  locator.registerLazySingleton(() => SearchController());

  //Dependent Services
  locator.registerSingletonAsync<FavoriteService>(() async {
    final favoriteService = FavoriteService();
    await favoriteService.init();
    return favoriteService;
  });
  await locator.isReady<FavoriteService>();
}