import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AdController extends GetxController {
  BannerAd? bannerAd;
  var isBannerAdLoaded = false.obs;
  final String _testDeviceId = 'bc50e66a-4872-4970-b7ca-2e9b28b56147';

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: [_testDeviceId]),
    );
    debugPrint('AdController: Initialized with test device $_testDeviceId');
    _loadBannerAd();
  }

  void _loadBannerAd() {
    isBannerAdLoaded.value = false;
    bannerAd?.dispose();

    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
          : 'ca-app-pub-3940256099942544/2934735716', // Test ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAdLoaded.value = true;
          debugPrint('AdController: Banner ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdController: Banner ad failed to load: $error');
          ad.dispose();
          isBannerAdLoaded.value = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 10), _loadBannerAd);
        },
        onAdOpened: (ad) => debugPrint('AdController: Banner ad opened'),
        onAdClosed: (ad) => debugPrint('AdController: Banner ad closed'),
      ),
    )..load();
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}
