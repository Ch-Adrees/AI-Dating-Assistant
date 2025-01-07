import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdManager {
  final BuildContext context;

  bool _isAdsBlocked = false; // Track if ads are blocked

  AdManager(this.context);

  // Method to check subscription status and block ads if active subscription
  Future<void> checkAndBlockAds() async {
    try {
      // Get customer info from RevenueCat
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      // Check if the user has an active subscription entitlement
      if (customerInfo.entitlements.all['entl675436f09b'] != null &&
          customerInfo.entitlements.all['entl675436f09b']?.isActive == true) {
        // User has an active subscription, block ads
        _isAdsBlocked = true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error checking subscription status')));
    }
  }


  // Show Banner Ads
  Future<void> showBannerAd() async {
    if(_isAdsBlocked) return;
    try {
      bool isBannerLoaded = await Appodeal.isLoaded(Appodeal.BANNER_BOTTOM);
      Appodeal.cache(Appodeal.BANNER_BOTTOM);
      if (isBannerLoaded) {
        Appodeal.show(Appodeal.BANNER_BOTTOM, 'BannerAds1');
      } else {

        Future.delayed(const Duration(seconds: 30), () {
          showBannerAd();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Show Interstitial Ads
  Future<void> showInterstitial() async {
    if(_isAdsBlocked) return;
    bool isReady = await Appodeal.isLoaded(Appodeal.INTERSTITIAL);
    if (isReady) {
      Appodeal.show(Appodeal.INTERSTITIAL, 'InterstitialAds1');
    }
  }

  // Show Reward Ads
  Future<void> showRewardedAd() async {
    if(_isAdsBlocked) return;
    bool isReady = await Appodeal.isLoaded(Appodeal.REWARDED_VIDEO);
    if (isReady) {
      Appodeal.show(Appodeal.REWARDED_VIDEO, 'RewardsAds1');
    }
  }
}
