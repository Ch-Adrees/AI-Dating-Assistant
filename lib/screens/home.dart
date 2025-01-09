import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/ads/banner_ads.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/screens/assistant.dart';
import 'package:rizzhub/screens/ice_first_message.dart';
import 'package:rizzhub/widgets/drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ads/ads_manager.dart';
import '../controllers/views/offering_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _setIsFirstLaunchFalse();
  }



  Future<void> _setIsFirstLaunchFalse() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return BannerAd(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Builder(builder: (context) {
                return CustomAppBar(
                    whichScreen: "home",
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    });
              })),
          drawer: const CustomDrawer(),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                CustomButton(

                  //text: "Ice Breaker",

                  text: 'ice_breaker'.tr,
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                    Get.to(
                      () => const IceAndFirstMessage(toScreen: "ice"),
                    );
                  },
                ),
                CustomButton(
                  text: 'need_assistance'.tr,
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                    Get.to(() => const AssistantScreen());
                  },
                ),
                CustomButton(

                  text: 'generate_first_message'.tr,
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                    Get.to(
                      () => const IceAndFirstMessage(toScreen: "first"),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}