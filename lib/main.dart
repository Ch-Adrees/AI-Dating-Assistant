import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/theme.dart';
import 'package:rizzhub/controllers/internet_controller.dart';
import 'package:rizzhub/screens/home.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(InternetController());

  await Firebase.initializeApp(
    name: 'Woorizz',
    options: const FirebaseOptions(
      apiKey: "AIzaSyDtoQDSe8qWtgs0llxAOPt4wQ4NSPRWGlE",
      appId: "1:1066647473944:android:08f9c34e4891cae33dd86d",
      messagingSenderId: "1066647473944",
      projectId: "conversation-questions-finder",
    ),
  );
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
        home:const  HomeScreen());
  }
}