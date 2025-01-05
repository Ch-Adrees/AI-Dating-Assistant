import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/controllers/views/data_boarding_controller.dart';
import 'package:rizzhub/l10n/l10n.dart';
import 'package:rizzhub/provider/locale_provider.dart';
import 'package:rizzhub/screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DataBoardingScreen extends StatelessWidget {
  const DataBoardingScreen({super.key});
  final List<String> dropDownValues = const ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: GetBuilder<DataBoardingController>(
            init: DataBoardingController(),
            builder: (controller) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome_to_chat_assistant,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.woo_rizz,
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: "Poppins",
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: controller.ageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(18.0),
                      hintText: AppLocalizations.of(context)!.enter_your_age,
                      label: Text(
                        AppLocalizations.of(context)!.yours_age,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                  DropdownMenu(
                    label: Text(
                      AppLocalizations.of(context)!.select_gender,
                      style:
                          const TextStyle(color: Colors.white, fontFamily: "Poppins"),
                    ),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 18),
                    width: MediaQuery.of(context).size.width * 0.9,
                    dropdownMenuEntries: dropDownValues.map((String gender) {
                      return DropdownMenuEntry(value: gender, label: gender);
                    }).toList(),
                  ),
                 LanguageDropdown(),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                            colors: [Colors.red, Colors.white54])),
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const HomeScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.lets_start_messaging,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Poppins"),
                              ),
                              const Icon(
                                Icons.arrow_circle_right,
                                color: Colors.black,
                                size: 40,
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}


// // Import necessary packages at the top
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rizzhub/l10n/l10n.dart';
// import 'package:rizzhub/provider/locale_provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:rizzhub/components/constants.dart';

// Add this code in the appropriate place in your data boarding screen
class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final currentLocale = provider.locale ?? const Locale('en');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DropdownMenu(
        label: Text(
          AppLocalizations.of(context)!.select_language,
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
          return DropdownMenuEntry(
            value: locale,
            label: languageName,
          );
        }).toList(),
        initialSelection: currentLocale,
        onSelected: (Locale? selectedLocale) {
          if (selectedLocale != null) {
            provider.setLocale(selectedLocale);

            // Confirmation SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${L10n.getLanguageName(selectedLocale.languageCode)} selected',
                  style: const TextStyle(fontFamily: "Poppins"),
                ),
                backgroundColor: Constants.buttonBgColor,
              ),
            );
          }
        },
      ),
    );
  }
}
