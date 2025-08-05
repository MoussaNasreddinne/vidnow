
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Handles loading and showing both interstitial and banner ads.
class AdService {
  
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

  
  BannerAd? bannerAd;

  final ValueNotifier<bool> isBannerAdLoaded = ValueNotifier(false);

  
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712' // Test ID
          : 'ca-app-pub-3940256099942544/4411468910', // Test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _isInterstitialAdLoaded = false;
    } else {
      debugPrint('Ad not loaded yet');
      loadInterstitialAd();
    }
  }

  
  // Public method to load a banner ad.
  void loadBannerAd() {
    bannerAd?.dispose();
    isBannerAdLoaded.value = false;

    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' 
          : 'ca-app-pub-3940256099942544/2934735716', 
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded successfully');
          // Notify listeners that the ad is loaded.
          isBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: $error');
          //retry loading after a delay.
          Future.delayed(const Duration(seconds: 5), loadBannerAd);
        },
      ),
    )..load();
  }

  
  void disposeBannerAd() {
    bannerAd?.dispose();
    isBannerAdLoaded.dispose();
  }
}