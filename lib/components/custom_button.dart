import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {super.key, required this.onTap, required this.text, this.color});
  final String text;
  final VoidCallback onTap;
  final Color? color;



  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Constants.buttonBgColor,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 50),
        ),
        onPressed: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Constants.whiteSecondaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ));
  }
}
