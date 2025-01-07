import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:provider/provider.dart';

import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/components/custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rizzhub/l10n/l10n.dart';
import '../ads/ads_manager.dart';

import '../provider/counter_provider.dart';

import '../provider/locale_provider.dart';

class IceAndFirstMessage extends StatefulWidget {
  const IceAndFirstMessage({super.key, required this.toScreen});
  final String toScreen;

  @override
  State<IceAndFirstMessage> createState() => _IceAndFirstMessageState();
}

class _IceAndFirstMessageState extends State<IceAndFirstMessage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _responseController = TextEditingController();
  List<String> _seenDocIds = [];

  // Get the user's selected language code
 Future<String> _getUserSelectedLanguage(BuildContext context) async {
  final locale = Provider.of<LocaleProvider>(context, listen: false).locale;
  return locale?.languageCode ?? 'en'; // Default to English
}

  // Map language codes to TranslateLanguage
  TranslateLanguage getTranslateLanguage(String userSelectedLanguage) {
    switch (userSelectedLanguage.toLowerCase()) {
      case 'ar': // Arabic
        return TranslateLanguage.arabic;
      case 'de': // German
        return TranslateLanguage.german;
      case 'el': // Turkish
        return TranslateLanguage.greek;
      case 'es': // Spanish
        return TranslateLanguage.spanish;
      case 'fr': // French
        return TranslateLanguage.french;
      case 'hi': // Hindi
        return TranslateLanguage.hindi;
      case 'it': // Italian
        return TranslateLanguage.italian;
      case 'nl': // Dutch
        return TranslateLanguage.dutch;
      case 'pt': // Portuguese
        return TranslateLanguage.portuguese;
      case 'ru': // Russian
        return TranslateLanguage.russian;
      case 'tr': // Turkish
        return TranslateLanguage.turkish;
      case 'zh': // Chinese
        return TranslateLanguage.chinese;
      default:
        return TranslateLanguage.english; // Default to English
    }
  }

  // Fetch a random document and translate it
  Future<void> fetchRandomDocument() async {
    try {
      String userSelectedLanguage = await _getUserSelectedLanguage(context);
      String collectionName =
          widget.toScreen == 'first' ? 'conversationstarter' : 'randomtopic';

      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<DocumentSnapshot> unseenDocs = querySnapshot.docs
            .where((doc) => !_seenDocIds.contains(doc.id))
            .toList();

        if (unseenDocs.isEmpty) {
          _seenDocIds.clear();
          unseenDocs = querySnapshot.docs;
          Get.snackbar('Information', 'All documents seen, starting over.');
        }

        int randomIndex = Random().nextInt(unseenDocs.length);
        DocumentSnapshot randomDoc = unseenDocs[randomIndex];
        _seenDocIds.add(randomDoc.id);

        final data = randomDoc.data() as Map<String, dynamic>?;
        String question = data?['question'] ?? 'No question available';

        String translatedText =
            await translateText(question, userSelectedLanguage);

        setState(() {
          _responseController.text = translatedText;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'No documents found in the $collectionName collection.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching random document: $e')),
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

    final counterProvider = Provider.of<CounterProvider>(context);

    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
       // String userSelectedLanguage = localeProvider.locale?.languageCode ?? 'en';
        return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          Get.back();
        },
      ),
      body: SafeArea(
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
                        hintText: AppLocalizations.of(context)!.random_response,
                        label: AppLocalizations.of(context)!.response,
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
                            content: Text(AppLocalizations.of(context)!.copied),
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
                  onTap: () async {

                    await counterProvider
                        .incrementCounter(); // Increment counter
                    if (counterProvider.counter >= counterProvider.threshold) {
                      final AdManager adManager = AdManager(context);
                      await adManager.showRewardedAd();
                      counterProvider
                          .resetCounter(); // Reset counter after showing the ad
                    }
                    await fetchRandomDocument();
                  },
                  text: AppLocalizations.of(context)!.random_generator,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
  }
    );
}
}
