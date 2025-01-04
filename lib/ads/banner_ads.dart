import 'package:flutter/material.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'ads_manager.dart';

class BannerAd extends StatelessWidget {
  final Widget child; // Content of the page

  const BannerAd({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    // Show the banner ad when the page is created
    //Appodeal.show(Appodeal.BANNER_BOTTOM);
    final AdManager adManager = AdManager(context);
    adManager.showBannerAd();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: child), // Page content
            ],
          ),
          // Display banner ad at the bottom
          Align(
           // alignment: Alignment.bottomCenter,
            child:
            AppodealBanner(adSize: AppodealBannerSize.BANNER, placement: "BannerAds1"),
          ),
        ],
      ),
    );
  }
}
