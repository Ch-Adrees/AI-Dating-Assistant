import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/screens/onbaording.dart';
import 'package:rizzhub/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController());
  Utils.configureRevenueCatWithApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeOfApp.appTheme,
        home: const OnboardingScreen());
  }
}
