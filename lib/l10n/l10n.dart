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
    const Locale('id'),
    const Locale('ms'),
    const Locale('fil'),
    const Locale('ja'),
    const Locale('pl'),
    const Locale('ko'),
    const Locale('vi'),
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
      case 'id':
        return '🇮🇩';
      case 'ms':
        return '🇲🇾';
      case 'fil':
        return '🇵🇭';
      case 'ja':
        return '🇯🇵';
      case 'pl':
        return '🇵🇱';
     case 'ko':
        return '🇰🇷';
      case 'vi':
        return '🇻🇳';
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
      case 'id':
        return 'Indonesia';
      case 'ms':
        return 'Malaysia';
      case 'fil':
        return 'Philippines';
      case 'ja':
        return 'Japan';
      case 'pl':
        return 'Poland';
      case 'ko':
        return 'South Korea';
      case 'vi':
        return 'Vietnam';

      default:
        return 'Unknown';
    }
  }
}
