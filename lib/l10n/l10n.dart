import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('hi'),
    const Locale('es'),
    const Locale('de'),
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
      default:
        return 'Unknown';
    }
  }
}