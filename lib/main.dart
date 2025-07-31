import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:test1/controllers/ad_controller.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/widgets/bottom_nav_bar.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/screens/home.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/service_locator.dart'; // Import the service locator

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await setupLocator(); // Initialize GetIt dependencies

  locator<AdService>().loadInterstitialAd(); // Use the locator to get the AdService instance

  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['bc50e66a-4872-4970-b7ca-2e9b28b56147'],
    ),
  );
  debugPrint('Mobile Ads SDK initialized: ${await MobileAds.instance.getVersionString()}');
  
  runApp(
    GetMaterialApp(debugShowCheckedModeBanner: false, home: MainWrapper()),
  );
}

class MainWrapper extends StatelessWidget {
  // Retrieve controller instances from the locator
  final NavController navController = locator<NavController>();
  final AdController adController = locator<AdController>();

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => navController.pages[navController.currentIndex.value],
              ),
            ),
            Obx(
              () => adController.isBannerAdLoaded.value
                  ? Container(
                      height: adController.bannerAd!.size.height.toDouble(),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AdWidget(ad: adController.bannerAd!),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}