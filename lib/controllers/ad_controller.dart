import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdController extends GetxController {
  BannerAd? bannerAd;
  var isBannerAdLoaded = false.obs;
  final String testDeviceId = 'bc50e66a-4872-4970-b7ca-2e9b28b56147'; 

  @override
  void onInit() {
    super.onInit();
    _loadBannerAd();
  }

  void _loadBannerAd() {
  bannerAd?.dispose();
  
  
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['bc50e66a-4872-4970-b7ca-2e9b28b56147'], 
    ),
  );

  
  final request = AdRequest();

  bannerAd = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: request, 
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        isBannerAdLoaded.value = true;
        print('Test banner ad loaded successfully');
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        print('Banner ad failed: $error');
        Future.delayed(Duration(seconds: 5), _loadBannerAd);
      },
    ),
  )..load();
}

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }
}