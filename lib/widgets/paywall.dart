import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rizzhub/components/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({super.key, required this.offering});

  @override
  // ignore: library_private_types_in_public_api
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(children: <Widget>[
          Container(
            height: 60.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Constants.buttonBgColor,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18.0))),
            child: Center(
                child: Text(
                  'woo_rizz_premium_subscriptions'.tr,
                  style: allTextStyle(18),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 32, bottom: 16, left: 16.0, right: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: Text(
               'rizz_subscription_catalog'.tr,
                style: allTextStyle(16),
              ),
            ),
          ),
          ListView.builder(
            itemCount: widget.offering.availablePackages.length,
            itemBuilder: (BuildContext context, int index) {
              var myProductList = widget.offering.availablePackages;
              return Card(
                color: Constants.buttonBgColor,
                child: ListTile(
                    onTap: () async {
                      try {
                        CustomerInfo customerInfo =
                        await Purchases.purchasePackage(
                            myProductList[index]);
                        EntitlementInfo? entitlement = customerInfo
                            .entitlements.all['entl675436f09b'];
                        debugPrint("Entitlement is $entitlement");
                      } catch (e) {
                        print("EROR is $e");
                      }

                      // setState(() {});
                      // Navigator.pop(context);
                    },
                    title: Text(
                      myProductList[index].storeProduct.title,
                      style: allTextStyle(14),
                    ),
                    subtitle: Text(
                      myProductList[index].storeProduct.description,
                      style: allTextStyle(12),
                    ),
                    trailing: Text(
                      myProductList[index].storeProduct.priceString,
                      style: allTextStyle(16),
                    )),
              );
            },
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 25, bottom: 10, left: 10.0, right: 10.0),
            child: SizedBox(
              height: 40,
              width: double.infinity,
              child: Text(
                'woo_rizz_offering_subscriptions'.tr,
                style: allTextStyle(14),
                textAlign:
                TextAlign.center, // This aligns the text to the center
                maxLines:
                3, // Optional: Limit the text to a specific number of lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  TextStyle allTextStyle(double fontSize) {
    return TextStyle(
        color: Colors.white, fontFamily: "Poppins", fontSize: fontSize);
  }
}
