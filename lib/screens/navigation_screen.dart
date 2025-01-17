import 'package:flutter/material.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/screens/assistant.dart';
import 'package:rizzhub/screens/break_silence.dart';
import 'package:rizzhub/screens/ice_first_message.dart';
import 'package:rizzhub/widgets/drawer.dart';

import '../components/constants.dart';

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
    FirstMessage()
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(

          color: Colors.white, // Background color of the navigation bar
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
              onTap: (int index) {
                setState(() {
                  selectedIndex = index;
                  //New case has been Solved
                });
              },
              backgroundColor: Colors.red,
              items: [
                BottomNavigationBarItem(
                  label: "Break Silence",
                  icon: Icon(
                    Icons.topic,
                    color: selectedIndex == 0 ? Colors.black : Colors.white,
                  ),
                ),
                BottomNavigationBarItem(
                  label: "Assistant Screen",
                  icon: Icon(Icons.home,
                      color: selectedIndex == 1 ? Colors.black : Colors.white,),
                ),
                BottomNavigationBarItem(
                  label: "First Message",
                  icon: Icon(Icons.search,
                      color: selectedIndex == 2 ? Colors.black : Colors.white,),
                )
              ]),
        ),
      ),
    );
  }
}
