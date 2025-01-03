import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:rizzhub/components/custom_text_field.dart';

import '../ads/ads_manager.dart';

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
  final TranslateLanguage sourceLanguage = TranslateLanguage.english;

  Future<void> fetchRandomDocument() async {
    try {
      // Determine the collection based on the toScreen value
      String collectionName =
          widget.toScreen == 'first' ? 'conversationstarter' : 'randomtopic';

      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Filter out already seen documents
        List<DocumentSnapshot> unseenDocs = querySnapshot.docs
            .where((doc) => !_seenDocIds.contains(doc.id))
            .toList();

        if (unseenDocs.isEmpty) {
          // Reset if all documents have been seen
          _seenDocIds.clear();
          unseenDocs = querySnapshot.docs;
          Get.snackbar('Information', 'All documents seen, starting over.');
        }

        // Get a random document from the unseen documents
        int randomIndex = Random().nextInt(unseenDocs.length);
        DocumentSnapshot randomDoc = unseenDocs[randomIndex];

        // Add the document ID to the seen list
        _seenDocIds.add(randomDoc.id);

        final data = randomDoc.data() as Map<String, dynamic>?;
        String question = data?['question'] ?? 'No question available';
        String translatedText =
            await translateText(question, TranslateLanguage.turkish);

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

  Future<String> translateText(
      String text, TranslateLanguage targetLanguage) async {
    final onDeviceTranslator = OnDeviceTranslator(
        sourceLanguage: sourceLanguage, targetLanguage: targetLanguage);

    try {
      final String translated = await onDeviceTranslator.translateText(text);
      return translated;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Translation error: $e')),
      );
      return 'Translation Failed';
    } finally {
      onDeviceTranslator.close();
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IntrinsicHeight(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: CustomTextfield(
                          readOnly: true,
                          maxLines: 5,
                          hintText: 'Randomly Generated Response',
                          label: 'Response',
                          controller: _responseController,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomIconButton(
                    onTap: () {
                      if (_responseController.text.isNotEmpty) {
                        Clipboard.setData(
                            ClipboardData(text: _responseController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Copied: Response copied to clipboard')),
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
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              CustomButton(
                onTap: ()async{
                  final AdManager adManager = AdManager(context);
                  await adManager.showRewardedAd();
                  fetchRandomDocument();
                },
                text: "Random Grenerator",
              ),


              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      )),
    );
  }
}
