import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  
  RemoteConfigService._(this._remoteConfig);

  
  static Future<RemoteConfigService> create() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    
    await remoteConfig.setDefaults(<String, Object>{
      'api_base_url': 'https://d2p4ou0is754xb.cloudfront.net',
      'default_theme_is_dark': true,
      'default_language_code': 'en',
      'android_banner_ad_unit_id': 'ca-app-pub-3940256099942544/6300978111', 
      'android_interstitial_ad_unit_id': 'ca-app-pub-3940256099942544/1033173712',
});

   
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: kDebugMode ? const Duration(seconds: 10) : const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();

    return RemoteConfigService._(remoteConfig);
  }

  //  Getters for all remote values 
  String get apiBaseUrl => _remoteConfig.getString('api_base_url');
  bool get defaultThemeIsDark => _remoteConfig.getBool('default_theme_is_dark');
  String get defaultLanguageCode => _remoteConfig.getString('default_language_code');
  String get bannerAdUnitId => _remoteConfig.getString('android_banner_ad_unit_id');
  String get interstitialAdUnitId => _remoteConfig.getString('android_interstitial_ad_unit_id');
}