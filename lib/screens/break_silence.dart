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
import 'package:shared_preferences/shared_preferences.dart';
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

  final CounterController counterController =
      Get.put(CounterController()); // Initialize CounterController

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

  String? _lastFetchedDocIdBreak; // Stores the ID of the last fetched document

  Future<void> fetchSequentialDocument() async {
    try {
      String userSelectedLanguage = await _getUserSelectedLanguage();
      String collectionName = 'randomtopic';

      // Query the collection with explicit ordering by document ID
      Query query = _firestore
          .collection(collectionName)
          .orderBy(FieldPath.documentId) // Order by Firestore's document ID
          .limit(1);

      // If there's a previously fetched document ID, use it to start after
      if (_lastFetchedDocIdBreak != null) {
        DocumentSnapshot? lastDoc = await _getDocumentById(_lastFetchedDocIdBreak!);
        if (lastDoc != null) {
          query = query.startAfterDocument(lastDoc);
        }
      }

      QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot nextDoc = querySnapshot.docs.first;
        _lastFetchedDocIdBreak = nextDoc.id; // Save the document ID
        await _saveLastFetchedDocId(_lastFetchedDocIdBreak!); // Persist the document ID

        final data = nextDoc.data() as Map<String, dynamic>?;

        String question = data?['question'] ?? 'No question available';

        String translatedText =
        await translateText(question, userSelectedLanguage);

        setState(() {
          _responseController.text = translatedText;
        });
      } else {
        // Reset if all documents have been fetched
        _lastFetchedDocIdBreak = null;
        await _saveLastFetchedDocId(null); // Clear saved document ID
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All documents fetched, restarting.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching document: $e')),
      );
    }
  }

  Future<void> _saveLastFetchedDocId(String? docId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (docId != null) {
      await prefs.setString('lastFetchedDocIdBreak', docId);
    } else {
      await prefs.remove('lastFetchedDocIdBreak');
    }
  }

  Future<String?> _getLastFetchedDocId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastFetchedDocIdBreak');
  }

  Future<DocumentSnapshot?> _getDocumentById(String documentId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('randomtopic')
          .doc(documentId)
          .get();
      return doc.exists ? doc : null;
    } catch (e) {
      print('Error fetching document by ID: $e');
      return null;
    }
  }

// Call this method in initState or when loading the screen
  Future<void> initializeLastFetchedDoc() async {
    _lastFetchedDocIdBreak = await _getLastFetchedDocId();
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
  void initState() {
    super.initState();
    initializeLastFetchedDoc().then((_) {
    });
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
                  counterController.incrementCounter();
                  int adCount = await counterController.getCounter();

                  if (adCount == counterController.threshold) {
                    final AdManager adManager = AdManager(context);
                    await adManager.showRewardedAd();
                    counterController.resetCounter();
                  }

                  await fetchSequentialDocument();
                },
                //text: 'random_generator'.tr,
                icon: Icons.search,
              ),
              AppodealBanner(adSize: AppodealBannerSize.BANNER, placement: "BannerAds1"),
            ],
          ),
        ),
      ),
    );
  }
}
