import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/provider/locale_provider.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:rizzhub/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/screens/onbaording.dart';
import 'components/constants.dart';
import 'provider/counter_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(InternetController());

  await Appodeal.initialize(
    appKey: 'edf0eeb97ff2d940bd1fc71234dc74d80f3eb7d06d96bf97' ,
    adTypes: [Appodeal.INTERSTITIAL, Appodeal.REWARDED_VIDEO, Appodeal.BANNER],
    onInitializationFinished: (errors) {},
  );

  await Firebase.initializeApp(
    name: 'Woorizz',
    options: FirebaseOptions(
      apiKey: 'AIzaSyDtoQDSe8qWtgs0llxAOPt4wQ4NSPRWGlE',
      appId: "1:1066647473944:android:08f9c34e4891cae33dd86d",
      messagingSenderId: "1066647473944",
      projectId: "conversation-questions-finder",
    ),
  );

  Utils.configureRevenueCatWithApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterProvider()..initializeCounter(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);
          return LocaleBlockingWrapper(
            child: Directionality(
              textDirection:
                  _getTextDirection(provider.locale ?? const Locale('en')),
              child: FutureBuilder(
                  future: _checkFirstLaunch(),
                  builder: (context, snapshot) {
                    // Show a loading indicator while checking first launch status
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: ThemeOfApp.appTheme,
                          home: Scaffold(
                              body: Center(
                        child: CircularProgressIndicator(
                          color: Constants.buttonBgColor,
                        ),
                      )));
                    }

                    // Once the check is complete, navigate to the correct screen
                    bool isFirstLaunch = snapshot.data ?? false;
                    return GetMaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Woo Rizz',
                      theme: ThemeOfApp.appTheme,
                      locale: provider.locale, // Use user-selected locale
                      supportedLocales: L10n.all,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      home: isFirstLaunch
                          ? const OnboardingScreen()
                          : const HomeScreen(),
                    );
                  }),
            ),
          );
        });
  }

  Future<bool> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    return isFirstLaunch;
  }

  /// Determines TextDirection based on the current locale
  TextDirection _getTextDirection(Locale locale) {
    const rtlLanguages = ['ar', 'ur', 'fa', 'he'];
    return rtlLanguages.contains(locale.languageCode)
        ? TextDirection.rtl
        : TextDirection.ltr;
  }
}

class LocaleBlockingWrapper extends StatefulWidget {
  final Widget child;

  const LocaleBlockingWrapper({required this.child});

  @override
  _LocaleBlockingWrapperState createState() => _LocaleBlockingWrapperState();
}

class _LocaleBlockingWrapperState extends State<LocaleBlockingWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Force the app to use the selected locale from LocaleProvider
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = provider.locale;

    // Check if the app's locale is different from the user-selected locale
    if (locales != null &&
        currentLocale != null &&
        locales.first != currentLocale) {
      // Reset the system locale to match the user-selected locale
      WidgetsBinding.instance.handleLocaleChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
