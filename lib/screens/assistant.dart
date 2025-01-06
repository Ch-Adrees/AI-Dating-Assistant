import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import '../ads/ads_manager.dart';
import '../components/constants.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../components/custom_icon.dart';
import '../components/custom_text_field.dart';
import '../controllers/views/assistant_screen_controller.dart';
import '../provider/locale_provider.dart';
import '../widgets/custom_emojies_row.dart';

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
  String _responseMessage = ''; // To store the ChatGPT response
  final TextEditingController _inputController = TextEditingController();

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

      setState(() {
        _recognizedText = recognizedText.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Recognized Text: $_recognizedText")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to recognize text: $e")),
      );
    } finally {
      textRecognizer.close();
    }
  }

  Future<String> _getUserSelectedLanguage(BuildContext context) async {
    final locale = Provider.of<LocaleProvider>(context, listen: false).locale;
    return locale?.languageCode ?? 'en'; // Default to English
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
    String prompt =
        "Respond to this message in a $selectedMood tone: \"$userInput\" and don't use emojis";

    try {
      const String apiKey =
          "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";
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4o-mini-2024-07-18",
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": prompt},
          ],
          "max_tokens": 100,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String generatedResponse =
            responseData['choices'][0]['message']['content'];

        String userSelectedLanguage = await _getUserSelectedLanguage(context);
        String translatedResponse =
            await translateText(generatedResponse, userSelectedLanguage);

        setState(() {
          _responseMessage = translatedResponse;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to generate response. ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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
                                    AppLocalizations.of(context)!.drag_drop,
                                    style: TextStyle(
                                        color: Constants.primaryColor),
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
                  Text(
                    AppLocalizations.of(context)!.or,
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextfield(
                    controller: _inputController,
                    hintText: AppLocalizations.of(context)!.paste_message,
                    label: AppLocalizations.of(context)!.input_message,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 15),
                  const CustomEmojiesRow(),
                  const SizedBox(height: 15),
                  CustomButton(
                    onTap: () async {
                      final AdManager adManager = AdManager(context);
                      await adManager.showRewardedAd();
                      _generateResponse();
                    },
                    text: AppLocalizations.of(context)!.submit,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextfield(
                          controller:
                              TextEditingController(text: _responseMessage),
                          label: AppLocalizations.of(context)!.response_message,
                          hintText: AppLocalizations.of(context)!.response_of_input,
                          maxLines: 3,
                          readOnly: true,
                        ),
                      ),
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
                                content: Text(AppLocalizations.of(context)!.copied),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
