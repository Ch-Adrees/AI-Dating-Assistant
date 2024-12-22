import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/controllers/views/assistant_screen_controller.dart';

class CustomEmojiesRow extends StatelessWidget {
  CustomEmojiesRow({super.key});
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssistantScreenController>(
      builder: (controller) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            List.generate(controller.emojies.length, (index) {
          return Row(
            children: [
              CustomIconButton(
                containerInnerColor: controller.index == index
                    ? controller.containerInnerColor
                    : null,
                width: 50,
                onTap: () {
                  controller.onTapEmojie(index);
                },
                centerItem: controller.emojies[index],
                fontSize: 30,
              ),
              if (index < controller.emojies.length - 1)
                const SizedBox(
                  width: 10,
                  child: Divider(thickness: 5),
                ),
            ],
          );
        }),
      ),
    );
  }
}
