import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.centerItem,
      this.height,
      this.fontSize,
      this.radius,
      this.width,
      required this.onTap,
      this.icon,
      this.containerInnerColor

      });
  final double? height, width, fontSize;
  final String? centerItem;
  final Icon? icon;
  final VoidCallback onTap;
  final double? radius;
  final Color? containerInnerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        height: height,
        width: width,

        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: Constants.primaryColor),
          borderRadius: BorderRadius.circular(radius ?? 100),
          color: containerInnerColor,
        ),
        child: InkWell(
          onTap: onTap,
          child: Align(
            alignment: Alignment.center,
            child: icon != null
                ? icon!
                : Text(
                    centerItem!,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: fontSize,
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ));
  }
}
