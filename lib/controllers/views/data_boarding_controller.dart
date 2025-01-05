import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataBoardingController extends GetxController {
  var selectedValue = "Male";
  final TextEditingController ageController = TextEditingController();

  void onChange(String value) {
    selectedValue = value;
    update();
  }
}
