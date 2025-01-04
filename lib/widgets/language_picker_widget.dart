import 'package:flutter/material.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class LanguagePickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');
    final flag = L10n.getFlag(locale.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        centerTitle: true,
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
                  'Current Language: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  flag,
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          Divider(),
          // List of Available Languages
          Expanded(
            child: ListView.builder(
              itemCount: L10n.all.length,
              itemBuilder: (context, index) {
                final locale = L10n.all[index];
                final flag = L10n.getFlag(locale.languageCode);

                return ListTile(
                  leading: Text(
                    locale.languageCode.toUpperCase(),
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Text(
                    flag,
                    style: TextStyle(fontSize: 24),
                  ),
                 onTap: () async {
  //final provider = Provider.of<LocaleProvider>(context, listen: false);
  provider.setLocale(locale);

  // Optionally show a confirmation message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Language changed to ${L10n.getLanguageName(locale.languageCode)}')),
  );

  // Close the screen after selection
  Navigator.of(context).pop();
},

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
