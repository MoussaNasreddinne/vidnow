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
import 'package:test1/services/auth_service.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test1/controllers/login_controller.dart';
import 'package:test1/controllers/auth_controller.dart';
import 'package:test1/controllers/forgot_password_controller.dart';
import 'package:test1/services/remote_config_service.dart';


GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Firebase Instances
  locator.registerLazySingleton(() => FirebaseAuth.instance);
  locator.registerLazySingleton(() => FirebaseFirestore.instance);
  
  // Services
  locator.registerSingletonAsync<RemoteConfigService>(() => RemoteConfigService.create());
  await locator.isReady<RemoteConfigService>();
  final remoteConfig = locator<RemoteConfigService>();
  locator.registerLazySingleton(() => VideoApiService(baseUrl: remoteConfig.apiBaseUrl));
  locator.registerLazySingleton(() => AdService(interstitialAdUnitId: remoteConfig.interstitialAdUnitId));
  locator.registerLazySingleton(() => AuthService()); 
  
  
  await locator.isReady<RemoteConfigService>();

  // initialized first since it needs shared preferences
  locator.registerSingletonAsync<FavoriteService>(() async {
    final favoriteService = FavoriteService();
    await favoriteService.init(); // Call the new initializer
    return favoriteService;
  });

  // Wait for FavoriteService to be ready before registering controllers that depend on it
  await locator.isReady<FavoriteService>();

  // Controllers 
  locator.registerLazySingleton(() => AdController(bannerAdUnitId: remoteConfig.bannerAdUnitId));
  locator.registerLazySingleton(() => ThemeController(defaultIsDark: remoteConfig.defaultThemeIsDark));
  locator.registerLazySingleton(() => LanguageController(defaultLanguageCode: remoteConfig.defaultLanguageCode));

  locator.registerLazySingleton(() => ForgotPasswordController());
  locator.registerLazySingleton(() => LoginController());
  //locator.registerLazySingleton(() => AdController());
  locator.registerLazySingleton(() => ButtonController());
  locator.registerLazySingleton(() => FavoritesController());
  locator.registerLazySingleton(() => LivestreamController());
  locator.registerLazySingleton(() => NavController());
  locator.registerLazySingleton(() => RecommendationController());
  //locator.registerLazySingleton(() => ThemeController());
  //locator.registerLazySingleton(() => LanguageController());
  locator.registerLazySingleton(() => AuthController());
  
}