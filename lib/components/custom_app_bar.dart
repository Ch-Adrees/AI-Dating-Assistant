import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_icon.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.menu,
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
              CupertinoIcons.arrow_up_left,
              color: Constants.primaryColor,
            ),
            height: 38,
            width: 50,
          ),
        )
      ],
    );
  }
}
