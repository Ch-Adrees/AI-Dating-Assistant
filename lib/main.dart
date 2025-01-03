import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:rizzhub/screens/onbaording.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Woo Rizz',
        theme: ThemeOfApp.appTheme,
        home: const OnboardingScreen());
  }
}