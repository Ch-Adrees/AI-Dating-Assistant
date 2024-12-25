import 'package:flutter/material.dart';
import 'package:rizzhub/components/custom_icon.dart';

class StylesButton extends StatelessWidget {
  const StylesButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return CustomIconButton(onTap: () {});
      }),
    );
  }
}
