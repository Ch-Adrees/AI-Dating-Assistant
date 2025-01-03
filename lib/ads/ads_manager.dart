import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdManager {
  final BuildContext context;

  AdManager(this.context);

  // Show Banner Ads
  Future<void> showBannerAd() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.BANNER_BOTTOM);
    if (isReady) {
      Appodeal.show(Appodeal.BANNER_BOTTOM);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner ads not ready')),
      );
    }
  }


  // Show Interstitial Ads
  Future<void> showInterstitial() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.INTERSTITIAL);
    if (isReady) {
      Appodeal.show(Appodeal.INTERSTITIAL);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interstitial ads not ready')),
      );
    }
  }

  // Show Reward Ads
  Future<void> showRewardedAd() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.REWARDED_VIDEO);
    if (isReady) {
      Appodeal.show(Appodeal.REWARDED_VIDEO);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewarded ads not ready')),
      );
    }
  }
}
