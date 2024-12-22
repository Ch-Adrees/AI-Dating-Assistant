import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/components/custom_textField.dart';
import 'package:rizzhub/controllers/views/assistant_screen_controller.dart';
import 'package:rizzhub/widgets/custom_emojies_row.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final AssistantScreenController _assistantScreenController =
      Get.put(AssistantScreenController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: ListView(
          children: [
            SafeArea(
                child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Constants.primaryColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.cloud_upload_outlined,
                          color: Constants.buttonBgColor,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const CustomTextfield(
                  hintText: "Paste Your Message Here",
                  label: "Input Message",
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomEmojiesRow(),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(onTap: () {}, text: "Submit"),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Expanded(
                        child: CustomTextfield(
                      label: "Response Message",
                      hintText: "Response Of Your Input",
                      maxLines: 3,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    CustomIconButton(
                      height: 55,
                      width: 55,
                      onTap: () {},
                      icon: Icon(
                        Icons.copy,
                        color: Constants.primaryColor,
                        size: 25,
                      ),
                    )
                  ],
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
