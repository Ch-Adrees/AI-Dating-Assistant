import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssistantScreenController extends GetxController {
  Color containerInnerColor= Colors.white54;
  int index = -1;
  final List<String> emojies = ["😂", "🧠", "😐", "♥", "😈"];
  String modeValue = "";

  void onTapEmojie(int i) {
    containerInnerColor = Colors.white54;
    index = i;
    switch (i) {
      case 0:
        modeValue = "happy";
        update();
        break;
      case 1:
        modeValue = "clever";
        update();
        break;
      case 2:
        modeValue = "neutral";
        update();
        break;
      case 3:
        modeValue = "flirty";
        update();
        break;
      case 4:
        modeValue = "extra flirty";
        update();
        break;
      default:
        modeValue = "";
        
    }

    update();
  }
}
