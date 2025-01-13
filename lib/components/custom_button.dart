import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.gradientColors,
  });

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradientColors != null
            ? LinearGradient(colors: gradientColors!)
            : null,
        borderRadius: BorderRadius.circular(12), // Add rounded corners
      ),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.cyanAccent,// Remove shadow for seamless gradient
            backgroundColor: color, // Transparent for gradient
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Match border radius
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Constants.whiteSecondaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
        ),
      ),
    );
  }
}
