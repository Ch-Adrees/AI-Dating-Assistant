import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/provider/locale_provider.dart';
import 'package:rizzhub/components/custom_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? const Locale('en');
    final flag = L10n.getFlag(locale.languageCode);
    final currentLanguageName = L10n.getLanguageName(locale.languageCode);


String languageChangedMessage = AppLocalizations.of(context)!.language_changed_to(currentLanguageName);


    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.select_language,
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
                  AppLocalizations.of(context)!.current_language,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor,
                  ),
                ),
                Text(
                  '$flag $currentLanguageName',
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
                    provider.setLocale(locale);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          languageChangedMessage,
                          style: TextStyle(color: Constants.primaryColor),
                        ),
                        backgroundColor: Constants.buttonBgColor,
                      ),
                    );
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
