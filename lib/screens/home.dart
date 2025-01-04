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

import '../ads/ads_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return BannerAd(
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
                text: AppLocalizations.of(context)!.generate_first_message,
                onTap: () async {
                  final AdManager adManager = AdManager(context);
                  await adManager.showInterstitial();
                  Get.to(
                    () => const IceAndFirstMessage(toScreen: "first"),
                  );
                },
              ),
              CustomButton(
                text: "Need Assistance ?",
                onTap: () async {
                  final AdManager adManager = AdManager(context);
                  await adManager.showInterstitial();
                  Get.to(() => const AssistantScreen());
                },
              ),
              CustomButton(
                text: "Ice Breaker",
                onTap: () async {
                  final AdManager adManager = AdManager(context);
                  await adManager.showInterstitial();
                  Get.to(
                    () => const IceAndFirstMessage(toScreen: "ice"),
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
    );
  }
}