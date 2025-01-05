import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingControlller extends GetxController {
  int selectedIndex = 0;
  PageController pageController = PageController();
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/Chat bot-cuate.png",
      "text": "Discover New Features",
      "rowText": "Generate Questions",
    },
    {
      "image": "assets/images/rb_5522.png",
      "text": "Welcome to Our App!",
      "rowText": "Access Random Topics",
    },
    {
      "image": "assets/images/rb_24649.png",
      "text": "Welcome to Our App!",
      "rowText": "Lets Start togather",
    }
  ];

  void changePage(int index) {
    selectedIndex = index;
    update();
  }
}
