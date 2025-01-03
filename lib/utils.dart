import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/widgets/custom_emojies_row.dart';

class Utils {
  static configureRevenueCatWithApp() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration? purchasesConfiguration;
    if (Platform.isAndroid) {
      purchasesConfiguration = PurchasesConfiguration(Constants.googlePlayApi)
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();

      // Fetch customer information to check the appUserID
      await Purchases.configure(purchasesConfiguration);
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all["Premium"] != null &&
          customerInfo.entitlements.all["Premium"]?.isActive == true) {
        debugPrint("The customer is  in if block  $CustomerInfo");
      } else {
        Offerings? offerings;
        try {
          offerings = await Purchases.getOfferings();
          debugPrint("The Offerings are $offerings");
        } on PlatformException catch (e) {
          debugPrint("The Error is ${e.message}");
        }
      }

      
    }
  }

  static getCustomerInfoFromRevenueCat() async {
    final purchaseInfo = await Purchases.getCustomerInfo();
    debugPrint(
        "The Entitlement ID of the Customer is ${purchaseInfo.entitlements.all[Constants.entitlementID]}");
    try {
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        debugPrint(
            "Current offering: ${offerings.current?.availablePackages.length}");
      } else {
        debugPrint(
            "No current offering available. Check your RevenueCat dashboard.");
      }
    } on PlatformException catch (e) {
      debugPrint("The Error is ${e.toString()}");
    }
  }
}
