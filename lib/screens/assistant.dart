import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rizzhub/controllers/views/offering_controller.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../ads/ads_manager.dart';
import '../components/constants.dart';
import '../components/custom_button.dart';
import '../components/custom_icon.dart';
import '../components/custom_text_field.dart';
import '../controllers/views/assistant_screen_controller.dart';
import '../controllers/locale_controller.dart';
import '../widgets/custom_emojies_row.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  // Navigation Controll

  final AssistantScreenController _assistantScreenController =
      Get.put(AssistantScreenController());
  final OfferingController _offeringController = Get.put(OfferingController());

  File? _selectedImage; // To store the selected image
  String _recognizedText = '';
  String _responseMessage = ''; // To store the ChatGPT response
  final TextEditingController _inputController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile.path);
      if (croppedFile != null) {
        setState(() {
          _selectedImage = File(croppedFile.path);
        });
        await _recognizeText(_selectedImage!);
      }
    }
  }

  Future<CroppedFile?> _cropImage(String filePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Constants.buttonBgColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
          ),
        ],
      );
      return croppedFile;
    } catch (e) {
      print("Error cropping image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to crop image: $e")),
      );
      return null;
    }
  }

  Future<void> _recognizeText(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();

    try {
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      setState(() {
        _recognizedText = recognizedText.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to recognize text: $e")),
      );
    } finally {
      textRecognizer.close();
    }
  }

  Future<String> _getUserSelectedLanguage() async {
    final locale = Get.find<LocaleController>().currentLocale;
    return locale.value.languageCode; // Return the current language code
  }

  TranslateLanguage getTranslateLanguage(String userSelectedLanguage) {
    switch (userSelectedLanguage.toLowerCase()) {
      case 'ar':
        return TranslateLanguage.arabic;
      case 'de':
        return TranslateLanguage.german;
      case 'es':
        return TranslateLanguage.spanish;
      case 'fr':
        return TranslateLanguage.french;
      case 'hi':
        return TranslateLanguage.hindi;
      case 'it':
        return TranslateLanguage.italian;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'ru':
        return TranslateLanguage.russian;
      case 'tr':
        return TranslateLanguage.turkish;
      case 'zh':
        return TranslateLanguage.chinese;
      default:
        return TranslateLanguage.english; // Default to English
    }
  }

  Future<String> translateText(String text, String userSelectedLanguage) async {
    final TranslateLanguage targetLanguage =
        getTranslateLanguage(userSelectedLanguage);
    final onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: targetLanguage,
    );

    try {
      final String translated = await onDeviceTranslator.translateText(text);
      return translated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Translation error: $e")),
      );
      return text; // Return original text if translation fails
    } finally {
      onDeviceTranslator.close();
    }
  }

  Future<void> manageUserAndStorePrompts(String prompt) async {
    try {
      // Check if a user is currently signed in
      User? currentUser = FirebaseAuth.instance.currentUser;

      // If no user exists, sign in anonymously
      if (currentUser == null) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInAnonymously();
        currentUser = userCredential.user;
      }

      if (currentUser != null) {
        // Get the user's UID
        String userId = currentUser.uid;

        // Reference to the user's document in Firestore
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);

        // Check if the user document exists
        DocumentSnapshot userSnapshot = await userDoc.get();
        if (!userSnapshot.exists) {
          // Create a new user document
          await userDoc.set({
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        // Store the prompt in the user's document (under a subcollection)
        await userDoc.collection('prompts').add({
          'prompt': prompt,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error Storing Prompts: $e");
    }
  }

  Future<void> _generateResponse() async {
    String userInput =
        _recognizedText.isNotEmpty ? _recognizedText : _inputController.text;

    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide an input.")),
      );
      return;
    }

    String selectedMood = _assistantScreenController.modeValue;
    if (selectedMood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please Select the Mood")),
      );
    }
    String prompt =
        "Respond to this message in a $selectedMood tone: \"$userInput\" and don't use emojis";
    await manageUserAndStorePrompts(prompt);

    try {
      String apiKey =
          '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';
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model":
              "gpt-4o-mini-2024-07-18", // Replace with the model you want to use

          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
          ],
          "max_tokens": 500,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String generatedResponse =
            responseData['choices'][0]['message']['content'];

        String userSelectedLanguage = await _getUserSelectedLanguage();
        String translatedResponse =
            await translateText(generatedResponse, userSelectedLanguage);

        setState(() {
          _responseMessage = responseData['choices'][0]['message']['content'];
          _responseMessage =
              _responseMessage.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

          _responseMessage = translatedResponse;
        });
        if (_selectedImage != null) {
          await _selectedImage!.delete();
          setState(() {
            _selectedImage = null; // Clear the image reference
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to generate response.  ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
  Future<void> _setIsFirstLaunchFalse() async {
    final prefs = await SharedPreferences.getInstance();
    // final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    // if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
    // }
  }

  @override
  void initState()  {
    super.initState();
    _setIsFirstLaunchFalse();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: ListView(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                InkWell(
                  onTap: _pickImage,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Constants.primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: Center(
                      child: _selectedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Constants.buttonBgColor,
                                  size: 60,
                                ),
                                Text(
                                  'drag_drop'.tr,
                                  style:
                                      TextStyle(color: Constants.primaryColor),
                                )
                              ],
                            )
                          : Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('or'.tr,
                    style: TextStyle(
                        color: Constants.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                CustomTextfield(
                  controller: _inputController,
                  hintText: 'paste_message'.tr,
                  label: 'input_message'.tr,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 15,
                ),
                const CustomEmojiesRow(),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                  onTap: () async {
                    if (_selectedImage != null &&
                        _inputController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please choose either an image or text input, not both.")),
                      );
                    } else if (_selectedImage == null &&
                        _inputController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please provide the Input")),
                      );
                    } else {
                      final AdManager adManager = AdManager(context);
                      await adManager.showRewardedAd();
                      await _generateResponse();
                    }
                  },
                  color: Colors.red,
                  text: 'submit'.tr,
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomTextfield(
                            controller:
                                TextEditingController(text: _responseMessage),
                            label: 'response_message'.tr,
                            hintText: 'response_of_input'.tr,
                            maxLines: 3,
                            readOnly: true)),
                    const SizedBox(width: 10),
                    CustomIconButton(
                      height: 55,
                      width: 55,
                      onTap: () {
                        if (_responseMessage.isNotEmpty) {
                          Clipboard.setData(
                            ClipboardData(text: _responseMessage),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('copied'.tr),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.copy,
                        color: Constants.primaryColor,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                AppodealBanner(adSize: AppodealBannerSize.BANNER, placement: "BannerAds1"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
