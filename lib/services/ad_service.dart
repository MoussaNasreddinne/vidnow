import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712' // Test ID
          : 'ca-app-pub-3940256099942544/4411468910', // Test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _isAdLoaded = false;
    } else {
      print('Ad not loaded yet');
      loadInterstitialAd();
    }
  }
}