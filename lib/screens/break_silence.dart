import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/components/custom_text_field.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import '../ads/ads_manager.dart';

import '../controllers/ad_counter_controller.dart';
import '../controllers/locale_controller.dart';
import '../controllers/ad_counter_controller.dart';
import '../controllers/locale_controller.dart';
 import 'dart:math';

//import '../provider/counter_provider.dart';

class BreakSilence extends StatefulWidget {
  const BreakSilence({super.key});
  //final String toScreen;

  @override
  State<BreakSilence> createState() => _IceAndFirstMessageState();
}

class _IceAndFirstMessageState extends State<BreakSilence> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _responseController = TextEditingController();
  
  final CounterController counterController = Get.put(CounterController()); // Initialize CounterController
// Initialize CounterController
  List<String> _seenDocIds = [];

  // Get the user's selected language code
  Future<String> _getUserSelectedLanguage() async {
    final locale = Get.find<LocaleController>().currentLocale;
    return locale.value.languageCode; // Return the current language code
  }

  // Map language codes to TranslateLanguage
  TranslateLanguage getTranslateLanguage(String userSelectedLanguage) {
    switch (userSelectedLanguage.toLowerCase()) {
      case 'ar':
        return TranslateLanguage.arabic;
      case 'de':
        return TranslateLanguage.german;
      case 'el':
        return TranslateLanguage.greek;
      case 'es':
        return TranslateLanguage.spanish;
      case 'fr':
        return TranslateLanguage.french;
      case 'hi':
        return TranslateLanguage.hindi;
      case 'it':
        return TranslateLanguage.italian;
      case 'nl':
        return TranslateLanguage.dutch;
      case 'pt':
        return TranslateLanguage.portuguese;
      case 'ru':
        return TranslateLanguage.russian;
      case 'tr':
        return TranslateLanguage.turkish;
      case 'zh':
        return TranslateLanguage.chinese;
      default:
        return TranslateLanguage.english;
    }
  }

  // Fetch a random document and translate it
  // DocumentSnapshot? _lastFetchedDoc; // Tracks the last fetched document

 
List<String> _documentIds = []; // List to store all document IDs
Set<String> _fetchedIds = {}; // Track fetched IDs to avoid repeats

Future<void> fetchRandomDocument() async {
  try {
    String userSelectedLanguage = await _getUserSelectedLanguage();
    String collectionName = 'randomtopic';

    // Load document IDs if not already loaded
    if (_documentIds.isEmpty) {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionName).get();
      _documentIds = snapshot.docs.map((doc) => doc.id).toList();
    }

    // Filter out already fetched IDs
    List<String> availableIds =
        _documentIds.where((id) => !_fetchedIds.contains(id)).toList();

    if (availableIds.isEmpty) {
      // Reset if all documents have been fetched
      _fetchedIds.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All documents fetched, restarting.')),
      );
      return;
    }

    // Pick a random ID
    String randomId = availableIds[Random().nextInt(availableIds.length)];

    // Fetch the document with the random ID
    DocumentSnapshot randomDoc =
        await _firestore.collection(collectionName).doc(randomId).get();

    _fetchedIds.add(randomId); // Mark this document as fetched

    final data = randomDoc.data() as Map<String, dynamic>?;

    String question = data?['question'] ?? 'No question available';

    String translatedText =
        await translateText(question, userSelectedLanguage);

    setState(() {
      _responseController.text = translatedText;
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching document: $e')),
    );
  }
}


  // Translate text using MLKit
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
        SnackBar(content: Text('Translation error: Try Again Later')),
      );
      return 'Translation Failed';
    } finally {
      onDeviceTranslator.close();
    }
  }

  @override
  Widget build(BuildContext context) {
   

    //return Obx(() {
    // final userSelectedLanguage = Get.find<LocaleController>().currentLocale.value.languageCode;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                IntrinsicHeight(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: CustomTextfield(
                      readOnly: true,
                      maxLines: 5,
                      hintText: 'random_response'.tr,
                      label: 'response'.tr,
                      controller: _responseController,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CustomIconButton(
                  onTap: () {
                    if (_responseController.text.isNotEmpty) {
                      Clipboard.setData(
                          ClipboardData(text: _responseController.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('copied'.tr),
                        ),
                      );
                    }
                  },
                  height: 55,
                  width: 55,
                  icon: Icon(
                    Icons.content_copy,
                    color: Constants.primaryColor,
                    size: 25,
                  ),
                ),
              ]),
              const SizedBox(height: 50),
              CustomButton(
                color: Colors.red,
                onTap: () async {
                  // await counterProvider.incrementCounter(); // Increment counter
                  // if (counterProvider.counter >= counterProvider.threshold) {
                  //   final AdManager adManager = AdManager(context);
                  //   await adManager.showRewardedAd();
                  //   counterProvider
                  //       .resetCounter(); // Reset counter after showing the ad
                  // }
                  await fetchRandomDocument();
                },
                //text: 'random_generator'.tr,
                icon: Icons.search,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
