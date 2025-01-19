import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    this.text,
    this.icon,
    this.color,
    this.gradientColors,
  });

  final String? text;
  final VoidCallback onTap;
  final Color? color;
  final List<Color>? gradientColors;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withValues(alpha: 0.3), // Shadow color
              spreadRadius: 9,                       // Spread radius
              blurRadius: 5,                         // Blur radius
              offset: Offset(2,2),                  // Shadow position (x, y)
            ),
          ],
          gradient: gradientColors != null
              ? LinearGradient(colors: gradientColors!)
              : null,
          borderRadius: BorderRadius.circular(12), // Add rounded corners
        ),
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
          child: icon != null
              ? Icon(
            icon,
            color: Constants.whiteSecondaryColor,
            size: 28,
          )
              :Text(
            text?? '',
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
