import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_app_bar.dart';
import 'package:rizzhub/components/custom_button.dart';
import 'package:rizzhub/components/custom_icon.dart';



class IceAndFirstMessage extends StatefulWidget {
  const IceAndFirstMessage({super.key, required this.toScreen});
  final String toScreen;


  @override
  State<IceAndFirstMessage> createState() => _IceAndFirstMessageState();

}

class _IceAndFirstMessageState extends State<IceAndFirstMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IntrinsicHeight(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: TextFormField(
                          maxLines: 5,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(9),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Poppins",
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CustomIconButton(
                    onTap: () {},
                    height: 55,
                    width: 55,
                    icon: Icon(
                      Icons.content_copy,
                      color: Constants.primaryColor,
                      size: 25,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(onTap: () {}, text: "Random Generator"),
            ],
          ),
        ),
      )),
    );
  }
}
