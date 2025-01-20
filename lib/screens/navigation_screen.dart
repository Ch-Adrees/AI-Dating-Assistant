import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/screens/assistant.dart';
import 'package:rizzhub/screens/break_silence.dart';
import 'package:rizzhub/screens/ice_first_message.dart';
import 'package:rizzhub/widgets/drawer.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../components/constants.dart';
import 'package:rizzhub/ads/ads_manager.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 1;
  List<Widget> _screens = [
    BreakSilence(),
    AssistantScreen(),
    FirstMessage(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Builder(builder: (context) {
            return CustomAppBar(onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            });
          })),
      drawer: const CustomDrawer(),
      body: _screens[selectedIndex],
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [_screens[selectedIndex],AppodealBanner(adSize: AppodealBannerSize.BANNER, placement: "BannerAds1"),],
      // ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0), // Top-left corner
            topRight: Radius.circular(16.0), // Top-right corner
          ),

        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
              onTap: (int index) async {
                final AdManager adManager = AdManager(context);
                await adManager.showInterstitial();
                setState(() {
                  selectedIndex = index;
                  //New case has been Solved
                });
              },
              backgroundColor: Constants.buttonBgColor,
              selectedItemColor: Color(0xFF1B1B29), // Color for selected label and icon
              unselectedItemColor: Colors.white,    // Color for unselected label and icon
              items: [
                BottomNavigationBarItem(
                  label: "ice_breaker".tr,
                  icon: Icon(
                    Icons.topic,
                    //color: selectedIndex == 0 ? Color(0xFF1B1B29) : Colors.white,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "need_assistance".tr,
                  icon: Icon(Icons.smart_toy,
                    //color: selectedIndex == 1 ? Color(0xFF1B1B29) : Colors.white,),
                  ),),
                BottomNavigationBarItem(
                  label: "generate_first_message".tr,
                  icon: Icon(Icons.send,
                    // color: selectedIndex == 2 ? Color(0xFF1B1B29) : Colors.white,),
                  ),),
              ]),
        ),
      ),
    );
  }
}