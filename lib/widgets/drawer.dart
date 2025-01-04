import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rizzhub/components/custom_tile.dart';
import 'package:rizzhub/screens/ice_first_message.dart';
import 'package:rizzhub/widgets/language_picker_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ads/ads_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  final String playStoreUrl =
      "https://play.google.com/store/apps/details?id=com.rizzlabs.rizz";

  final String privacyPolicyUrl =
      "https://doc-hosting.flycricket.io/woo-rizz-ai-dating-assistant/cd611d47-afa8-41e1-a84f-e27093450eb4/privacy";

  final String deleteDataRequestFormUrl = "https://forms.gle/7AogzANezhFCW6q9A";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: ClipOval(
                      child: Image.asset("assets/logos/WOO RIZZ.png"),
                    ),
                  ),
                ],
              )),
              CustomListTile(
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                    if (await canLaunchUrl(Uri.parse(privacyPolicyUrl))) {
                      await launchUrl(Uri.parse(privacyPolicyUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Could not open Privacy Policy link")),
                      );
                    }
                  },
                  icon: const Icon(Icons.privacy_tip_outlined),
                  title: "Privacy Policy"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                    if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
                      await launchUrl(Uri.parse(playStoreUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("Could not open the Play Store link")),
                      );
                    }
                  },
                  icon: const Icon(Icons.star_border),
                  title: "App Rating"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();

                    if (await canLaunchUrl(Uri.parse(deleteDataRequestFormUrl))) {
                      await launchUrl(Uri.parse(deleteDataRequestFormUrl),
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text("Could not open Google Form")),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                  title: "Delete Data Request"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () async {
                    final AdManager adManager = AdManager(context);
                    await adManager.showInterstitial();
                  },
                  icon: const Icon(Icons.notification_important),
                  title: "VIP"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () async {
                    // final AdManager adManager = AdManager(context);
                    // await adManager.showInterstitial();
                     Get.to(
                    () =>LanguagePickerScreen(),
                  );
                  },
                  icon: const Icon(Icons.language),
                  title: "Language "),
            ],
          ),
        ),
      ),
    );
  }
}
