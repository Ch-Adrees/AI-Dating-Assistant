import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';


class Utils {
  static configureRevenueCatWithApp() async {
    await Purchases.setLogLevel(LogLevel.debug);
    PurchasesConfiguration? purchasesConfiguration;
    if (Platform.isAndroid) {
      purchasesConfiguration = PurchasesConfiguration('goog_lTDQFwqDJzbxUrzLXQZoQexzQQN')
        ..appUserID = null
        ..purchasesAreCompletedBy = const PurchasesAreCompletedByRevenueCat();
      await Purchases.configure(purchasesConfiguration);
    }
  }


}