import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  var currentLocale = const Locale('en').obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void setLocale(Locale locale) async {
    currentLocale.value = locale;
    update();
    await _saveLocale(locale);
    
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('locale') ?? 'en';
    currentLocale.value = Locale(languageCode);
    update();
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }
}

