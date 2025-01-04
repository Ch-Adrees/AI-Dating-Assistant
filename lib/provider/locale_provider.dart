import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rizzhub/l10n/l10n.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  // Set a new locale and save it in SharedPreferences
  void setLocale(Locale locale) async {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
    await _saveLocale(locale);
  }

  // Clear the saved locale and set the default locale (English)
  void clearLocale() async {
    _locale = const Locale('en');
    notifyListeners();
    await _clearSavedLocale();
  }

  // Load the saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale');

    if (languageCode != null && L10n.all.any((locale) => locale.languageCode == languageCode)) {
      // If the saved locale exists and is valid, use it
      _locale = Locale(languageCode);
    } else {
      // Default to English if no saved locale or invalid locale is found
      _locale = const Locale('en');
    }
    notifyListeners(); // Notify listeners after loading the locale
  }

  // Save the selected locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  // Clear the saved locale from SharedPreferences
  Future<void> _clearSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('locale');
  }
}
