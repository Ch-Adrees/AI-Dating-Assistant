import 'package:flutter/material.dart';
import 'ads_manager.dart';

class BannerAd extends StatelessWidget {
  final Widget child; // Content of the page

  const BannerAd({required this.child, super.key});

  @override
  Widget build(BuildContext context) {

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
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100, // Set the height of the banner ad
              //child: Appodeal.show(Appodeal.BANNER_BOTTOM);
            ),
          ),
        ],
      ),
    );
  }
}