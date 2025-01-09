import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataBoardingController extends GetxController {
  //var selectedValue = "Male";
  final TextEditingController ageController = TextEditingController();

  //   // Variables to store selected gender and language
  String? selectedGender;
  String? selectedLanguage;

  void onChange(String value) {
    selectedGender = value;
    update();
  }
}
