import 'package:flutter/material.dart';
import 'package:rizzhub/components/custom_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
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
                      child: Image.asset("assets/logos/club.png"),
                    ),
                  ),
                ],
              )),
              CustomListTile(
                  onTap: () {},
                  icon: const Icon(Icons.privacy_tip_outlined),
                  title: "Privacy Policy"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () {},
                  icon: const Icon(Icons.star_border),
                  title: "App Rating"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () {},
                  icon: const Icon(Icons.delete_outline),
                  title: "Delete"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () {},
                  icon: const Icon(Icons.notification_important),
                  title: "VIP"),
              const SizedBox(
                height: 10,
              ),
              CustomListTile(
                  onTap: () {},
                  icon: const Icon(Icons.language),
                  title: "Language "),
            ],
          ),
        ),
      ),
    );
  }
}
