import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/loading_dialog.dart';
import 'package:rizzhub/services/internet_service.dart';

class InternetController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  RxString message = "loading".obs;
  InternetService? internetService;

  @override
  void onInit() async {
    super.onInit();
    internetService = InternetService();
    message.value = await internetService!.initConnectivity();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      checkConnectivityChange(connectivityResults);
    });
  }

  void checkConnectivityChange(List<ConnectivityResult> results) async {
    message.value = await internetService!.onConnectivityChange(results);
    if (message.value == "none") {
      showDialog();
    }
    debugPrint("Message Value ${message.value}");
  }

  Future<bool> pingServer() async {
    message.value = "loading";
    return await internetService!.pingServer();
  }

  void showDialog() {
    Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Constants.buttonBgColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            height: 250,
            width: 300,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  ' Your connection has been lost. Please check your internet connection and try again.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () {
                          Get.back();
                        },
                        color: Colors.black45,
                        text: "Okay",
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomButton(
                            onTap: () {
                              bool isConnected = false;
                              Get.back();
                              Get.dialog(const LoadingDialog());
                              Future.delayed(const Duration(seconds: 3),
                                  () async {
                                isConnected = await pingServer();
                                if (isConnected) {
                                  message.value = "connected";
                                  Get.back();
                                } else {
                                  Get.back();
                                  showDialog();
                                }
                              });
                            },
                            color: Colors.black45,
                            text: "Retry")),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
