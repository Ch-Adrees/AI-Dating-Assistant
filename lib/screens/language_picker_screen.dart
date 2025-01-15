import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_tile.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/controllers/locale_controller.dart';

class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the LocaleController
    final localeController = Get.find<LocaleController>();
    final currentLocale = localeController.currentLocale;
    final currentFlag = L10n.getFlag(currentLocale.value.languageCode);
    final currentLanguageName = L10n.getLanguageName(currentLocale.value.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'select_language'.tr,
          style: TextStyle(
            color: Constants.whiteSecondaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Constants.buttonBgColor,
        iconTheme: IconThemeData(color: Constants.whiteSecondaryColor),
      ),
      body: Column(
        children: [
          // Current Selected Language Display
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'current_language'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor,
                  ),
                ),
                SizedBox(width: 8), // Add spacing between text and flag
                Text(
                  '$currentFlag $currentLanguageName',
                  style: TextStyle(
                    fontSize: 20,
                    color: Constants.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white54),
          // List of Available Languages
          Expanded(
            child: ListView.builder(
              itemCount: L10n.all.length,
              itemBuilder: (context, index) {
                final locale = L10n.all[index];
                final flag = L10n.getFlag(locale.languageCode);
                final languageName = L10n.getLanguageName(locale.languageCode);

                return CustomListTile(
                  onTap: () {
                    Get.updateLocale(locale);
                    // Set locale using GetX controller
                  localeController.setLocale(locale);

                    // Show confirmation SnackBar
                   // final languageChangedMessage = 'hello';
                        // AppLocalizations.of(context)!
                        //     .language_changed_to(languageName);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       languageChangedMessage,
                    //       style: TextStyle(color: Constants.primaryColor),
                    //     ),
                    //     backgroundColor: Constants.buttonBgColor,
                    //   ),
                    // );
                    Navigator.of(context).pop();
                  },
                  icon: Text(
                    flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: languageName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}