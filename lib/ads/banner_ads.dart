import 'package:flutter/material.dart';
//import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'ads_manager.dart';

class BannerAd extends StatelessWidget {
  // Content of the page

  const BannerAd({ super.key});

  @override
  Widget build(BuildContext context) {

    final AdManager adManager = AdManager(context);
    adManager.showBannerAd();

    return Scaffold(
      body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100, // Set the height of the banner ad
              //child: Appodeal.show(Appodeal.BANNER_BOTTOM);
            ),
          ),
      
    );
  }
}