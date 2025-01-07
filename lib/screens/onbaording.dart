import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/controllers/views/onboarding_controlller.dart';
import 'package:rizzhub/screens/data_boarding.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GetBuilder<OnboardingControlller>(
          init: OnboardingControlller(),
          builder: (controller) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "AI Assistant Rizz",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: controller.onboardingData.length,
                  onPageChanged: (index) {
                    controller.changePage(index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      image: controller.onboardingData[index]["image"]!,
                      index: index,
                    );
                  },
                ),
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
                      onTap: (){
                           Get.to(() =>  DataBoardingScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.onboardingData[controller.selectedIndex]
                                  ['rowText']!,
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
                          )
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;

  final int index;

  const OnboardingPage({super.key, required this.image, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          width: MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          )),
        ),
        GetBuilder<OnboardingControlller>(
          builder: (controller) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.onboardingData.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: controller.selectedIndex == index
                      ? Colors.red
                      : Colors.transparent,
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
