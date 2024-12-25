import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';


class InternetService {
  static final Connectivity _connectivity = Connectivity();

  Future<String> initConnectivity() async {
    String message = "";
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile) &&
              await pingServer() == true) {
        message = "connected";
      }
    } catch (e) {
      message = "none";
      debugPrint("No internet Connection ${e.toString()}");
    }
    return message;
  }

  Future<String> onConnectivityChange(List<ConnectivityResult> result) async {
    String message = "";
    if ((result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi))&& await pingServer()) {
      message = "connected";
    } else {
      message = "none";
    }
    return message;
  }

  Future<String> checkInternetQuality() async {
    String message = "";
    try {
      final hasInternet = await pingServer();
      if (hasInternet) {
        message = "connected";
      } else {
        var goodConnection = await pingServer();
        message = goodConnection ? "connected" : "none";
      }
    } catch (e) {
      message = "none";
    }
    return message;
  }

  Future<bool> pingServer() async {
    try {
      final result = await InternetAddress.lookup("www.google.com")
          .timeout(const Duration(seconds: 10), onTimeout: () {
        return [];
      });
      debugPrint("Raw address is ${result[0].rawAddress}");
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
