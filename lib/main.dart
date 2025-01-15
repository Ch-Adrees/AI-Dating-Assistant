
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/languages.dart';

import 'package:rizzhub/controllers/locale_controller.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:rizzhub/screens/onbaording.dart';
import 'package:rizzhub/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'components/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(
  //     testDeviceIds: ['85F0A91FF9C1E99B68214CC21246DCD5'],
  //   ),
  // );

  // Initialize GetX controllers
  Get.put(InternetController());
  Get.put(LocaleController());
  // Set the Appodeal app keys
// Appodeal.setAppKeys(
//   androidAppKey: 'edf0eeb97ff2d940bd1fc71234dc74d80f3eb7d06d96bf97',
//   // iosAppKey: '<your-appodeal-ios-key>',
// );

// Initialize Appodeal
// await Appodeal.initialize(
//   hasConsent: true,
//   adTypes: [AdType.banner, AdType.interstitial, AdType.reward],
//   testMode: true,
//   verbose: true,
// );

//At this point you are ready to display ads
  //Initialize Appodeal
  Appodeal.initialize(
    appKey: "edf0eeb97ff2d940bd1fc71234dc74d80f3eb7d06d96bf97",
    adTypes: [
      AppodealAdType.Interstitial,
      AppodealAdType.RewardedVideo,
      AppodealAdType.Banner,
    ],
    onInitializationFinished: (errors) => {});
    Appodeal.setTabletBanners(true);
    Appodeal.setSmartBanners(true);

  // Initialize Firebase
  await Firebase.initializeApp(
    name: 'Woorizz',
    options: FirebaseOptions(
      apiKey: 'AIzaSyDtoQDSe8qWtgs0llxAOPt4wQ4NSPRWGlE',
      appId: "1:1066647473944:android:08f9c34e4891cae33dd86d",
      messagingSenderId: "1066647473944",
      projectId: "conversation-questions-finder",
    ),
  );

  // Configure RevenueCat
  Utils.configureRevenueCatWithApp();

  runApp(
      LocaleBlockingWrapper(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Woo Rizz',
        theme: ThemeOfApp.appTheme,
        translations: AppTranslations(),
        locale: localeController.currentLocale.value,
        fallbackLocale: const Locale('en'),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: FutureBuilder<bool>(
          future: _checkFirstLaunch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeOfApp.appTheme,
                  home: Scaffold(
                      body: Center(
                    child: CircularProgressIndicator(
                      color: Constants.buttonBgColor,
                    ),
                  )
                  )
                  );
            }

            final isFirstLaunch = snapshot.data ?? true;
            return isFirstLaunch
                ? const OnboardingScreen()
                : const HomeScreen();
          },
        ),
      );
    });
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isLaunch = prefs.getBool('isFirstLaunch') ?? true;
    print(isLaunch);
    return isLaunch;
  }
}

class LocaleBlockingWrapper extends StatefulWidget {
  final Widget child;

  const LocaleBlockingWrapper({required this.child, Key? key})
      : super(key: key);

  @override
  _LocaleBlockingWrapperState createState() => _LocaleBlockingWrapperState();
}

class _LocaleBlockingWrapperState extends State<LocaleBlockingWrapper>
    with WidgetsBindingObserver {
  late final LocaleController _localeController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _localeController = Get.find<LocaleController>();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Prevent system locale changes from affecting the app
    final currentLocale = _localeController.currentLocale.value;

    if (locales != null &&
        locales.isNotEmpty &&
        locales.first != currentLocale) {
      WidgetsBinding.instance.handleLocaleChanged(); // Reset to app locale
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
