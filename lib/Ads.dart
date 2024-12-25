import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'package:flutter/material.dart';

class AdManager {
  final BuildContext context;

  AdManager(this.context);

  Future<void> showBanner() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.BANNER);
    if (!isReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Banner ads not ready')),
      );
      return;
    } else {
      Appodeal.show(Appodeal.BANNER, 'BannerAds1');
    }
  }

  Future<void> showInter() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.INTERSTITIAL);
    if (!isReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Interstitial ads not ready')),
      );
      return;
    } else {
      Appodeal.show(Appodeal.INTERSTITIAL, 'InterstitialAds1');
    }
  }

  Future<void> showReward() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.REWARDED_VIDEO);
    if (!isReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rewarded ads not ready')),
      );
      return;
    } else {
      Appodeal.show(Appodeal.REWARDED_VIDEO, 'RewardsAds1');
    }
  }
}
