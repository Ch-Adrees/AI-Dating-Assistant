import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdManager {
  final BuildContext context;

  AdManager(this.context);

  void preloadBannerAd() async {
  Appodeal.cache(Appodeal.BANNER);
}

  // Show Banner Ads
  Future<void> showBannerAd() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.BANNER);
    if (!isReady) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banner ads not ready')),
      );
      return;
    } else {
      Appodeal.show(Appodeal.BANNER,'BannerAds1');
    }

     // Retry after a delay
    // Future.delayed(const Duration(seconds: 5), () {
    //   showBannerAd(); // Retry showing the ad
    //   });

  }


  // Show Interstitial Ads
  Future<void> showInterstitial() async {
    bool isReady = await Appodeal.isLoaded(Appodeal.INTERSTITIAL);
    if (isReady) {
      Appodeal.show(Appodeal.INTERSTITIAL,'InterstitialAds1');
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
      Appodeal.show(Appodeal.REWARDED_VIDEO, 'RewardsAds1');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewarded ads not ready')),
      );
    }
  }
}
