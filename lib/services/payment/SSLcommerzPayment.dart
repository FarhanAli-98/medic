// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

// ignore_for_file: prefer_single_quotes, prefer_final_locals, deprecated_member_use

import 'dart:async';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_sslcommerz/model/SSLCAdditionalInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCEMITransactionInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCShipmentInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/General.dart';
import 'package:flutter_sslcommerz/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';

class SSLCommerzPayment extends StatefulWidget {
  const SSLCommerzPayment({Key key}) : super(key: key);
  @override
  _SSLCommerzPaymentState createState() => _SSLCommerzPaymentState();
}

class _SSLCommerzPaymentState extends State<SSLCommerzPayment> {
  final String userId = LocatorService.userProvider().user.uid;
  final String userName = LocatorService.userProvider().user.name;
  final String userPhoneNumber = LocatorService.userProvider().user.phoneNumber;
  final String userEmail = LocatorService.userProvider().user.email;
  final String doctorId = LocatorService.consultationProvider().doctor.uid;
  final String amount = LocatorService.consultationProvider().amount.toString();
  final String title = LocatorService.consultationProvider().title;

  Future<void> sslCommerzCustomizedCall() async {
    print(userEmail);
    print(userName);
    print(userPhoneNumber);
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            ipn_url: "www.ipnurl.com",
            multi_card_name: "visa,master,bkash",
            currency: SSLCurrencyType.BDT,
            product_category: "Medical",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "skyxa607f228f403e3",
            // store_id: 'testbox',
            store_passwd: 'qwerty',
            total_amount: double.parse(amount),
            tran_id: "1231321321321312"));
    sslcommerz
        .addEMITransactionInitializer(
            sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
                emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        // .addShipmentInfoInitializer(
        //     sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
        //         shipmentMethod: "yes",
        //         numOfItems: 5,
        //         shipmentDetails: ShipmentDetails(
        //             shipAddress1: "Ship address 1",
        //             shipCity: "Faridpur",
        //             shipCountry: "Bangladesh",
        //             shipName: "Ship name 1",
        //             shipPostCode: "7860")))
        .addCustomerInfoInitializer(
            customerInfoInitializer: SSLCCustomerInfoInitializer(
                customerName: userName.toString(),
                customerEmail: userEmail.toString(),
                customerAddress1: null,
                customerCity: null,
                customerPostCode: null,
                customerCountry: null,
                customerPhone: userPhoneNumber.toString(),
                customerState: ''))
        .addProductInitializer(
            sslcProductInitializer:
                // ***** ssl product initializer for general product STARTS*****
                SSLCProductInitializer(
                    productName: "Medical",
                    productCategory: "doctor consultant",
                    general: General(
                        general: "General Purpose",
                        productProfile: "Product Profile"))
            // ***** ssl product initializer for general product ENDS*****

            // ***** ssl product initializer for non physical goods STARTS *****
            // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
            //     productName:
            //   "productName",
            //   productCategory:
            //   "productCategory",
            //   nonPhysicalGoods:
            //   NonPhysicalGoods(
            //      productProfile:
            //       "Product profile",
            //     nonPhysicalGoods:
            //     "non physical good"
            //       ))
            // ***** ssl product initializer for non physical goods ENDS *****

            // ***** ssl product initialization for travel vertices STARTS *****
            //       SSLCProductInitializer.WithTravelVerticalProfile(
            //          productName:
            //         "productName",
            //         productCategory:
            //         "productCategory",
            //         travelVertical:
            //         TravelVertical(
            //               productProfile: "productProfile",
            //               hotelName: "hotelName",
            //               lengthOfStay: "lengthOfStay",
            //               checkInTime: "checkInTime",
            //               hotelCity: "hotelCity"
            //             )
            //       )
            // ***** ssl product initialization for travel vertices ENDS *****

            // ***** ssl product initialization for physical goods STARTS *****

            // SSLCProductInitializer.WithPhysicalGoodsProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     physicalGoods: PhysicalGoods(
            //         productProfile: "Product profile",
            //         physicalGoods: "non physical good"))

            // ***** ssl product initialization for physical goods ENDS *****

            // ***** ssl product initialization for telecom vertice STARTS *****
            // SSLCProductInitializer.WithTelecomVerticalProfile(
            //     productName: "productName",
            //     productCategory: "productCategory",
            //     telecomVertical: TelecomVertical(
            //         productProfile: "productProfile",
            //         productType: "productType",
            //         topUpNumber: "topUpNumber",
            //         countryTopUp: "countryTopUp"))
            // ***** ssl product initialization for telecom vertice ENDS *****
            )
        .addAdditionalInitializer(
            sslcAdditionalInitializer: SSLCAdditionalInitializer(
                valueA: "value a ",
                valueB: "value b",
                valueC: "value c",
                valueD: "value d"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("GGGGG_______GGGG__________");
      // print("the response is: " + result.message + " code: " + result.code);
    } else {
      SSLCTransactionInfoModel model = result;
      String tempPaymentID = '112106211517021nhok6Ttn7P1RNh';
      //TODO: set payment method
      LocatorService.appointmentSetupProvider().setAppoinetmentUID =
          tempPaymentID;
      //model.bankTranId;

      // Setup paymentDocUID to have reference for payment document with appointment
      // document
      LocatorService.appointmentSetupProvider().setPaymentDocUID =
          tempPaymentID;
      // model.bankTranId;

      NavigationController.navigator
          .popAndPush(Routes.appointmentSetupController);
    }
  }

  // Future<void> handleUrlChange(String url) async {
  //   if (mounted) {
  //     debugPrint('Url has changed $url');
  //
  //     if (url.contains('success')) {
  //       final u = Uri.parse(url).queryParameters['data'];
  //       final result = jsonDecode(u);
  //       print('$result');
  //       dispose();
  //
  //       // Setup appointmentUID to create an appointment document with that ID
  //       LocatorService.appointmentSetupProvider().setAppoinetmentUID =
  //       result['appointmentId'];
  //
  //       // Setup paymentDocUID to have reference for payment document with appointment
  //       // document
  //       LocatorService.appointmentSetupProvider().setPaymentDocUID =
  //       result['paymentDocId'];
  //
  //       NavigationController.navigator
  //           .popAndPush(Routes.appointmentSetupController);
  //       return;
  //     }
  //
  //     if (url.contains('failed')) {
  //       dispose();
  //       Fluttertoast.showToast(
  //           msg: 'Error occured during payment. Please try again');
  //       NavigationController.navigator.pop();
  //       return;
  //     }
  //   }
  // }
  @override
  void initState() {
    super.initState();
    print("_________________DDDD___________");
    sslCommerzCustomizedCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.payment),
      ),
      //   body: ,
    );
  }
}

class Progress extends StatefulWidget implements PreferredSizeWidget {
  const Progress({
    Key key,
    @required this.flutterWebviewPlugin,
  }) : super(key: key);

  final FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  _PState createState() => _PState();

  @override
  Size get preferredSize => const Size.fromHeight(10.0);
}

class _PState extends State<Progress> {
  StreamSubscription<double> _onProgressChanged;
  bool showProgress = true;

  @override
  void initState() {
    super.initState();
    _onProgressChanged =
        widget.flutterWebviewPlugin.onProgressChanged.listen(handleProgress);
  }

  @override
  void dispose() {
    _onProgressChanged?.cancel();
    widget.flutterWebviewPlugin?.close();
    widget.flutterWebviewPlugin?.dispose();
    super.dispose();
  }

  void handleProgress(double progress) {
    if (mounted) {
      if (progress == 1.0) {
        setState(() {
          showProgress = false;
        });
      } else {
        setState(() {
          showProgress = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade200,
      child: showProgress
          ? Theme(
              data: ThemeData(accentColor: Colors.blueAccent),
              child: const LinearProgressIndicator(),
            )
          : const SizedBox(),
    );
  }
}
