import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rizzhub/widgets/paywall.dart';

class OfferingController extends GetxController {
  Offerings? offerings;
  bool isLoadingOfferings = false;

  void checkOfferings(BuildContext context) async {
    try {
      isLoadingOfferings = true;
      update();
      offerings = await Purchases.getOfferings();
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all['entl675436f09b'] != null &&
          customerInfo.entitlements.all['entl675436f09b']?.isActive == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have an active subscription!')),
        );
      } else {
        try {
          Get.bottomSheet(
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Container(
                  height: offerings == null ? 150 : 450,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      top: BorderSide(color: Colors.white54, width: 2),
                      left: BorderSide(
                          color: Colors.white54, width: 2), // Left border
                      right: BorderSide(
                          color: Colors.white54, width: 2), // Top border
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  child: offerings == null
                      ? LoadingAnimationWidget.threeArchedCircle(
                      color: Colors.red, size: 35)
                      : Paywall(
                      offering: offerings!
                          .current!) // Set the height of your bottom sheet
              ),
            ),
            isScrollControlled:
            true, // Optional: allow scrolling if content overflows
          );

          isLoadingOfferings = false;

          update();

          if (offerings != null && offerings!.current != null) {
            // Get.back();
          }
        } on PlatformException catch (e) {
          debugPrint("The Error is ${e.message}");
        }
      }
    } catch (e) {
      debugPrint("The Error is ${e.toString()}");
    }
  }
}
