import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/components/custom_text_field.dart';
import 'package:rizzhub/controllers/views/assistant_screen_controller.dart';
import 'package:rizzhub/widgets/custom_emojies_row.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final AssistantScreenController _assistantScreenController =
      Get.put(AssistantScreenController());

  File? _selectedImage; // To store the selected image
  String _recognizedText = '';

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _recognizeText(_selectedImage!);
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      // Store the recognized text in a variable
      setState(() {
        _recognizedText = recognizedText.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recognized Text: $_recognizedText")),
      );
      print("Recognized Text: $_recognizedText");
    } catch (e) {
      print("Error recognizing text: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to recognize text: $e")),
      );
    } finally {
      textRecognizer.close();
    }
  }

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
                  onTap: _pickImage,
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
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Constants.buttonBgColor,
                                  size: 60,
                                ),
                                Text("Drag n Drop or Pick an Image",
                                    style: TextStyle(
                                        color: Constants.primaryColor))
                              ],
                            )
                          : Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("OR",
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                const CustomTextfield(
                  hintText: "Paste Your Message Here",
                  label: "Input Message",
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 15,
                ),
                const CustomEmojiesRow(),
                const SizedBox(
                  height: 15,
                ),
                //CustomButton(onTap: () {}, text: "Submit"),
                CustomButton(
                  onTap: () {
                    if (_recognizedText.isNotEmpty) {
                      print(
                          "Using Recognized Text for Response: $_recognizedText");
                      // Call your response generation logic here
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "No text recognized. Please upload an image.")),
                      );
                    }
                  },
                  text: "Submit",
                ),

                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Expanded(
                        child: CustomTextfield(
                            label: "Response Message",
                            //hintText: "Response Of Your Input",
                            maxLines: 3,
                            readOnly: true)),
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
