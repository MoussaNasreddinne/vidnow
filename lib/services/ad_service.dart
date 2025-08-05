import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;
  final String _testDeviceId = 'bc50e66a-4872-4970-b7ca-2e9b28b56147';

  Future<void> initialize() async {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: [_testDeviceId]),
    );
    debugPrint('AdService: Initialized with test device $_testDeviceId');
  }

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
          debugPrint('AdService: Interstitial ad loaded');
          
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('AdService: Interstitial ad dismissed');
              ad.dispose();
              _isInterstitialAdLoaded = false;
              loadInterstitialAd(); // Load a new ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('AdService: Failed to show interstitial ad: $error');
              ad.dispose();
              _isInterstitialAdLoaded = false;
              loadInterstitialAd(); // Load a new ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('AdService: Failed to load interstitial ad: $error');
          _isInterstitialAdLoaded = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), loadInterstitialAd);
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      try {
        _interstitialAd?.show();
        debugPrint('AdService: Showing interstitial ad');
      } catch (e) {
        debugPrint('AdService: Error showing interstitial ad: $e');
        loadInterstitialAd(); // Attempt to reload if showing fails
      }
    } else {
      debugPrint('AdService: Interstitial ad not ready, loading new one');
      loadInterstitialAd();
    }
  }
}