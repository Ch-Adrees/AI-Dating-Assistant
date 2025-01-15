import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:rizzhub/components/custom_icon.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/views/offering_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key, this.whichScreen, required this.onTap, this.widgetContext});
  final String? whichScreen;
  final VoidCallback onTap;
  final BuildContext? widgetContext;

  @override
  Widget build(BuildContext context) {
    final OfferingController _offeringController =
        Get.put(OfferingController());
    return AppBar(
      leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: IconButton(
              onPressed: onTap, icon: Icon(Icons.menu, color: Colors.white70))),
      centerTitle: true,
      title: CustomIconButton(
        onTap: () {
          _offeringController.checkOfferings(context);
        },
        centerItem: "VIP",
        width: 50,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CustomIconButton(
            onTap: () {
              Share.share(
                'https://play.google.com/store/apps/details?id=com.woo.rizz',
              );
            },
            icon: Icon(
              Icons.share,
              color: Constants.primaryColor,
            ),
            height: 38,
            width: 50,
          ),
          // CustomIconButton(
          //   height: 38,
          //     width: 50,
          //     icon: Icon((Icons.arrow_forward_ios),color: Colors.white,),
          //     onTap: (){
          //   Get.back();
          // }),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
