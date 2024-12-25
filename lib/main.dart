import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  appodealInitialize() async{
    await  Appodeal.initialize(
      appKey: 'edf0eeb97ff2d940bd1fc71234dc74d80f3eb7d06d96bf97',
      adTypes: [Appodeal.INTERSTITIAL, Appodeal.REWARDED_VIDEO, Appodeal.BANNER],
      onInitializationFinished: (errors) => {}
      );
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeOfApp.appTheme,
        home: const HomeScreen()
        );
  }
}