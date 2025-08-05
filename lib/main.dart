import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:test1/controllers/ad_controller.dart';
import 'package:test1/services/ad_service.dart';
import 'package:test1/widgets/bottom_nav_bar.dart';
import 'package:test1/controllers/nav_controller.dart';
import 'package:test1/widgets/gradient_background.dart';
import 'package:test1/service_locator.dart';
import 'package:test1/controllers/theme_controller.dart';
import 'package:test1/utils/app_themes.dart';
import 'package:test1/services/app_translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //initializing needed services
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocator();
  await locator<AdService>().initialize();
  locator<AdService>().loadInterstitialAd();
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['bc50e66a-4872-4970-b7ca-2e9b28b56147'],
    ),
  );
  debugPrint(
    'Mobile Ads SDK initialized: ${await MobileAds.instance.getVersionString()}',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = locator<ThemeController>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //rebuilds when theme changes
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        darkTheme: AppThemes.darkTheme,
        themeMode: themeController.theme,

        translations: AppTranslations(),

        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),

        home: MainWrapper(),
      ),
    );
  }
}

// wrapper widget the holds the main layout
class MainWrapper extends StatelessWidget {
  final NavController navController = locator<NavController>();
  final AdController adController = locator<AdController>();

  MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              //rebuilds to show the currently selected page
              child: Obx(
                () => navController.pages[navController.currentIndex.value],
              ),
            ),
            //rebuilds to show banner ad when loaded
            Obx(
              () => adController.isBannerAdLoaded.value
                  ? Container(
                      height: adController.bannerAd!.size.height.toDouble(),
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: AdWidget(ad: adController.bannerAd!),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
