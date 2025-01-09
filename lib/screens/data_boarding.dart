import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/controllers/views/data_boarding_controller.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/provider/locale_provider.dart';
//import 'package:rizzhub/provider/locale_prodart';
import 'package:rizzhub/screens/home.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class DataBoardingScreen extends StatelessWidget {
  DataBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DataBoardingController controller = Get.put(DataBoardingController());
   // final List<String> dropDownValues = ['male'.tr, 'female'.tr, 'other'.tr];

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'welcome_to_chat_assistant'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'woo_rizz'.tr,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: "Poppins",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: controller.ageController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18.0),
                    hintText: 'enter_your_age'.tr,
                    label: Text(
                      'yours_age'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
               GenderDropdown(),
                const SizedBox(height: 18),
                LanguageDropdown(
                  onLanguageChanged: () {
                    // Only rebuild the necessary parts of the app
                    controller.update();
                  },
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: const LinearGradient(
                        colors: [Colors.red, Colors.white54]),
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        if (controller.ageController.text.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Age is required.",
                            backgroundColor: Constants.buttonBgColor,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (controller.selectedGender == null) {
                          Get.snackbar(
                            "Error",
                            "Gender is required.",
                            backgroundColor: Constants.buttonBgColor,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        Get.to(() => const HomeScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'lets_start_messaging'.tr,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: "Poppins"),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_circle_right,
                            color: Colors.black,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// class DataBoardingController extends GetxController {
//   // Controller for the age input field
//   TextEditingController ageController = TextEditingController();

//   // Variables to store selected gender and language
//   String? selectedGender;
//   String? selectedLanguage;

//   // Lifecycle management: Dispose of the ageController when done
//   @override
//   void onClose() {
//     ageController.dispose();
//     super.onClose();
//   }
// }

// // Import necessary packages at the top

// Add this code in the appropriate place in your data boarding screen
class LanguageDropdown extends StatelessWidget {
  final VoidCallback onLanguageChanged;

  const LanguageDropdown({required this.onLanguageChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DropdownMenu<Locale>(
        label: Text(
          'select_language'.tr,
          style: TextStyle(
            color: Constants.primaryColor,
            fontFamily: "Poppins",
            fontSize: 16,
          ),
        ),
        textStyle: TextStyle(
          color: Constants.primaryColor,
          fontFamily: "Poppins",
          fontSize: 14,
        ),
        menuHeight: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.9,
        dropdownMenuEntries: L10n.all.map((locale) {
          final languageName = L10n.getLanguageName(locale.languageCode);
          return DropdownMenuEntry<Locale>(
            value: locale,
            label: languageName,
          );
        }).toList(),
        initialSelection: localeController.currentLocale.value,
        onSelected: (Locale? selectedLocale) {
          if (selectedLocale != null) {
            Get.updateLocale(selectedLocale);
            localeController.setLocale(selectedLocale);

            // Notify parent of the change
            onLanguageChanged();
          }
        },
      ),
    );
  }
}
class GenderDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataBoardingController>(
      builder: (controller) {
        final List<String> dropDownValues = ['male'.tr, 'female'.tr, 'other'.tr];
        return DropdownMenu(
                      label: Text(
                        'select_gender'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 18,
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      dropdownMenuEntries: dropDownValues.map((String gender) {
                        return DropdownMenuEntry(value: gender, label: gender);
                      }).toList(),
                      onSelected: (value) {
                        controller.selectedGender = value;
                        controller.update(); // Rebuild the widget
                      },
                      initialSelection: controller.selectedGender, // Persist value
                    );
      },
    );
  }
}
