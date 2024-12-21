import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onTap, required this.text});
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.buttonBgColor,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
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
