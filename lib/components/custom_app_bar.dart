import 'package:flutter/material.dart';

import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.whichScreen, required this.onTap, this.widgetContext});
  final String? whichScreen;
  final VoidCallback onTap;
  final BuildContext? widgetContext;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: onTap,
        icon: Icon(
          whichScreen != null && whichScreen == "home"
              ? Icons.menu
              : Icons.arrow_back_ios_rounded,
          color: Constants.primaryColor,
          size: 30,
        ),
      ),
      centerTitle: true,
      title: CustomIconButton(
        onTap: () {},
        centerItem: "VIP",
        width: 50,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomIconButton(
            onTap: () {},
            icon: Icon(
              Icons.share,
              color: Constants.primaryColor,
            ),
            height: 38,
            width: 50,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
