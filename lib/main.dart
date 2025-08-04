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


void main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Google Mobile Ads SDK
  await MobileAds.instance.initialize();

  // Initialize GetIt dependencies
  await setupLocator(); 

  // Use the locator to get the AdService and load an ad 
  locator<AdService>().loadInterstitialAd(); 

  // Configure test devices for ads
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: ['bc50e66a-4872-4970-b7ca-2e9b28b56147'],
    ),
  ); 

  // Print the Mobile Ads SDK version for debugging
  debugPrint('Mobile Ads SDK initialized: ${await MobileAds.instance.getVersionString()}');
  
  // Run the application with the new root widget
  runApp(MyApp());
}

// root widget to manage theme state at the top level
class MyApp extends StatelessWidget {
  // Retrieve the theme controller from the service locator
  final ThemeController themeController = locator<ThemeController>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        // Define the light theme for the app
        theme: AppThemes.lightTheme,
        // Define the dark theme for the app
        darkTheme: AppThemes.darkTheme,
        // Set the current theme mode based on the controller's state
        themeMode: themeController.theme,
  
        home: MainWrapper(),
      ),
    );
  }
}


class MainWrapper extends StatelessWidget {
  // Retrieve controller instances from the locator
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
            // Expanded takes up all available space for the main page content
            Expanded(
              child: Obx(
                // Display the current page based on the NavController's index
                () => navController.pages[navController.currentIndex.value],
              ),
            ),
            
            Obx(
              () => adController.isBannerAdLoaded.value
                  ? Container(
                      // Set the container height to the ad's height
                      height: adController.bannerAd!.size.height.toDouble(),
                      width: double.infinity,
                      alignment: Alignment.center,
                      // Display the ad widget
                      child: AdWidget(ad: adController.bannerAd!),
                    )
                  // If the ad is not loaded, show an empty container
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        // Set the bottom navigation bar for the Scaffold
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}