import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterProvider with ChangeNotifier {
  int _counter = 0;
  final int _threshold = 4; // Set the threshold for ad frequency

  int get counter => _counter;
  int get threshold => _threshold;

  // Initialize counter from SharedPreferences
  Future<void> initializeCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('adDisplayCounter') ?? 0;
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Set to false after the first launch
      await prefs.setBool('isFirstLaunch', false);
    }
    notifyListeners();
  }

  // Increment counter and save it to SharedPreferences
  Future<void> incrementCounter() async {
    _counter++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adDisplayCounter', _counter);
    notifyListeners();
  }

  // Reset the counter
  Future<void> resetCounter() async {
    _counter = 0;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adDisplayCounter', _counter);
    notifyListeners();
  }

  Future<bool> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    return isFirstLaunch;
  }
}
