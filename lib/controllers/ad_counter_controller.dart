import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterController extends GetxController {
  final _counter = 0.obs; // Observable variable for the counter
  final int threshold = 4; // Threshold for ad frequency

  int get counter => _counter.value;

  // Initialize counter from SharedPreferences
  Future<int> getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    _counter.value = prefs.getInt('adDisplayCounter') ?? 0;
    return _counter.value;
  }

  // Increment counter and save it to SharedPreferences
  Future<void> incrementCounter() async {
    _counter.value++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adDisplayCounter', _counter.value);
  }

  // Reset the counter
  Future<void> resetCounter() async {
    _counter.value = 0;
   
  }
  }