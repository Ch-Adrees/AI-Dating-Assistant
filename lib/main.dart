import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/screens/home.dart';

void main() {
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
        home: const HomeScreen());
  }
}
