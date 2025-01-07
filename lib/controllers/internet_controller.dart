import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/loading_dialog.dart';
import 'package:rizzhub/services/internet_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      showDialog(Get.context!);
    }
    debugPrint("Message Value ${message.value}");
  }

  Future<bool> pingServer() async {
    message.value = "loading";
    return await internetService!.pingServer();
  }

  // void showDialog(BuildContext context) {
  //   Get.dialog(
  //       barrierDismissible: false,
  //       Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12.0),
  //         ),
  //         elevation: 5,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: Constants.buttonBgColor,
  //             borderRadius: BorderRadius.circular(12.0),
  //           ),
  //           height: 250,
  //           width: 300,
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //                Text(
  //                 AppLocalizations.of(context)!.no_internet,
  //                 style: TextStyle(
  //                   fontFamily: "Poppins",
  //                   fontSize: 23,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               const SizedBox(height: 20),
  //                Text(
  //                 AppLocalizations.of(context)!.connection_lost,
  //                 textAlign: TextAlign.start,
  //                 style: TextStyle(
  //                   fontFamily: "Poppins",
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Expanded(
  //                   child: CustomButton(
  //                       onTap: () {
  //                         bool isConnected = false;
  //                         Get.back();
  //                         Get.dialog(const LoadingDialog());
  //                         Future.delayed(const Duration(seconds: 3),
  //                             () async {
  //                           isConnected = await pingServer();
  //                           if (isConnected) {
  //                             message.value = "connected";
  //                             Get.back();
  //                           } else {
  //                             Get.back();
  //                             showDialog(Get.context!);
  //                           }
  //                         });
  //                       },
  //                       color: Colors.black45,
  //                       text: AppLocalizations.of(context)!.retry)),
  //             ],
  //           ),
  //         ),
  //       ));
  // }
  void showDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 5,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Get screen dimensions
            double screenWidth = MediaQuery.of(context).size.width;
            double screenHeight = MediaQuery.of(context).size.height;

            return Container(
              width: screenWidth * 0.8, // 80% of screen width
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.5, // 50% of screen height
              ),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Constants.buttonBgColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Adjust to content size
                  children: [
                    Text(
                      AppLocalizations.of(context)!.no_internet,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.connection_lost,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      onTap: () {
                        bool isConnected = false;
                        Get.back();
                        Get.dialog(const LoadingDialog());
                        Future.delayed(const Duration(seconds: 3), () async {
                          isConnected = await pingServer();
                          if (isConnected) {
                            message.value = "connected";
                            Get.back();
                          } else {
                            Get.back();
                            showDialog(Get.context!);
                          }
                        });
                      },
                      color: Colors.black45,
                      text: AppLocalizations.of(context)!.retry,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
