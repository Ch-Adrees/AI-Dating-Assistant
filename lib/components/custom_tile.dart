import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key,
      required this.onTap,
      required this.icon,
      required this.title});
  final VoidCallback onTap;
  final Icon icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: icon,
      title: Text(title),
      iconColor: Constants.buttonBgColor,
      splashColor: Colors.white54,
      textColor: Constants.primaryColor,
    );
  }
}
