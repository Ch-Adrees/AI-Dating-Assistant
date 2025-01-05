import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('hi'),
    const Locale('es'),
    const Locale('de'),
    const Locale('fr'),
    const Locale('ru'),
    const Locale('pt'),
    const Locale('tr'),
    const Locale('el'),
    const Locale('nl'),
    const Locale('it'),
    const Locale('zh'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return '🇦🇪';
      case 'hi':
        return '🇮🇳';
      case 'es':
        return '🇪🇸';
      case 'de':
        return '🇩🇪';
      case 'fr':
        return '🇫🇷';
      case 'ru':
        return '🇷🇺';
      case 'pt':
        return '🇵🇹';
      case 'tr':
        return '🇹🇷';
      case 'el':
        return '🇬🇷';
      case 'nl':
        return '🇳🇱';
      case 'it':
        return '🇮🇹';
      case 'zh':
        return '🇨🇳';
      case 'en':
      default:
        return '🇺🇸';
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'Arabic';
      case 'hi':
        return 'Hindi';
      case 'es':
        return 'Spanish';
      case 'de':
        return 'German';
      case 'fr':
        return 'French';
      case 'ru':
        return 'Russian';
      case 'pt':
        return 'Portuguese';
      case 'tr':
        return 'Turkish';
      case 'el':
        return 'Greek';
      case 'nl':
        return 'Dutch';
      case 'it':
        return 'Italian';
      case 'zh':
        return 'Chinese';
      default:
        return 'Unknown';
    }
  }
}
