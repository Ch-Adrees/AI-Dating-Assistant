import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/languages.dart';
import 'package:rizzhub/provider/counter_provider.dart';
import 'package:rizzhub/provider/locale_provider.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:rizzhub/screens/onbaording.dart';
import 'package:rizzhub/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX controllers
  Get.put(InternetController());
  Get.put(LocaleController());

  // Initialize Appodeal
  await Appodeal.initialize(
    appKey: 'edf0eeb97ff2d940bd1fc71234dc74d80f3eb7d06d96bf97',
    adTypes: [Appodeal.INTERSTITIAL, Appodeal.REWARDED_VIDEO, Appodeal.BANNER],
    onInitializationFinished: (errors) {
      if (errors != null) {
        print("Appodeal initialization errors: $errors");
      }
    },
  );

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
    
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        // Add other providers here if needed
      ],
      child: LocaleBlockingWrapper(child: const MyApp()),
    ),
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
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
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
    return prefs.getBool('isFirstLaunch') ?? true;
  }
}

class LocaleBlockingWrapper extends StatefulWidget {
  final Widget child;

  const LocaleBlockingWrapper({required this.child, Key? key}) : super(key: key);

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
