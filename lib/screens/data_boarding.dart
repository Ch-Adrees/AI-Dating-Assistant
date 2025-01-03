import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/controllers/views/data_boarding_controller.dart';
import 'package:rizzhub/screens/home.dart';

class DataBoardingScreen extends StatelessWidget {
  const DataBoardingScreen({super.key});
  final List<String> dropDownValues = const ["Male", "Female", "Other"];
  final List<String> languages = const [
    "English",
    "Spanish",
    "Chinese (Mandarin)",
    "Hindi",
    "Arabic",
    "Bengali",
    "Portuguese",
    "Russian",
    "Japanese",
    "Punjabi",
    "German",
    "Javanese",
    "Korean",
    "French",
    "Turkish",
    "Vietnamese",
    "Telugu",
    "Marathi",
    "Tamil",
    "Urdu",
    "Filipino (Tagalog)",
    "Persian (Farsi)",
    "Italian",
    "Thai",
    "Gujarati",
    "Polish",
    "Ukrainian",
    "Kannada",
    "Malayalam",
    "Oriya",
    "Burmese",
    "Azerbaijani",
    "Hausa",
    "Swahili",
    "Serbian",
    "Khmer",
    "Nepali",
    "Sinhalese",
    "Uzbek",
    "Pashto",
    "Somali",
    "Amharic",
    "Greek",
    "Swedish",
    "Czech",
    "Belarusian",
    "Hungarian",
    "Finnish",
    "Dutch",
    "Romanian",
    "Hebrew",
    "Bulgarian",
    "Slovak",
    "Armenian",
    "Georgian",
    "Icelandic",
    "Latvian",
    "Lithuanian",
    "Estonian",
    "Malay",
    "Bosnian",
    "Yiddish",
    "Lao",
    "Mongolian",
    "Tigrinya",
    "Malagasy",
    "Zulu",
    "Xhosa",
    "Cebuano",
    "Wolof",
    "Kurdish",
    "Yoruba",
    "Fijian",
    "Samoan",
    "Tahitian",
    "Maori",
    "Breton",
    "Galician",
    "Welsh",
    "Basque",
    "Catalan",
    "Irish",
    "Cornish",
    "Albanian",
    "Macedonian",
    "Haitian Creole",
    "Quechua",
    "Kyrgyz",
    "Turkmen",
    "Tatar",
    "Pashto",
    "Punjabi",
    "Burmese",
    "Maltese",
    "Finnish",
    "Slovene",
    "Serbo-Croatian",
    "Tagalog",
    "Tibetan",
    "Somali",
    "Tigrinya",
    "Swahili",
    "Zulu",
    "Hmong",
    "Fijian",
    "Armenian",
    "Korean",
    "Khmer",
    "Lao",
  ];

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
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome to Chat Assistant ",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Woo Rizz!",
                        style: TextStyle(
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
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(18.0),
                      hintText: "Enter your age",
                      label: Text(
                        "Your's age",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ),
                  ),
                  DropdownMenu(
                    label: const Text(
                      "Select Gender",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Poppins"),
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
                  DropdownMenu(
                    label: const Text(
                      "Select Language",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Poppins"),
                    ),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 18),
                    menuHeight: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.9,
                    dropdownMenuEntries: languages.map((String language) {
                      return DropdownMenuEntry(
                          value: language, label: language);
                    }).toList(),
                  ),
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
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lets Start Messaging",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Poppins"),
                              ),
                              Icon(
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
