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

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentWebview extends StatefulWidget {
  const PaymentWebview({Key key}) : super(key: key);
  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  FlutterWebviewPlugin flutterWebViewPlugin;

  final String userId = LocatorService.userProvider().user.uid;
  final String doctorId = LocatorService.consultationProvider().doctor.uid;
  final String amount = LocatorService.consultationProvider().amount.toString();
  final String title = LocatorService.consultationProvider().title;

  String loadHtml() {
    return '''
    <html>
    <body onload='document.f.submit()'>
    <div style='display: flex; align-items: center; justify-content: center;'>
      <p>Processing payment. Please do not hit refresh or press back button</p>
    </div>
      <form id='f' name='f' method='POST' action='${Config.INITIATE_PAYMENT_URL}'>
        <input type='hidden' name='amount' value='$amount' />
        <input type='hidden' name='currency' value='${Config.CURRENCY}' />
        <input type='hidden' name='description' value='Medical Appointment payment for $title' />
        <input type='hidden' name='userId' value='$userId' />
        <input type='hidden' name='doctorId' value='$doctorId' />
      </form>
    </body>
    </html>
    ''';
  }

  // On urlChanged stream
  StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  StreamSubscription<WebViewHttpError> _onHttpError;

  @override
  void initState() {
    super.initState();
    log('Started Webview', name: 'Payment Webview');

    flutterWebViewPlugin = FlutterWebviewPlugin();

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen(handleUrlChange);

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        print('State changed ${state.type.toString()}');
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      print('${error.code} ${error.url}');
    });
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();

    // flutterWebViewPlugin.clearCache();
    flutterWebViewPlugin.cleanCookies();
    flutterWebViewPlugin?.close();
    flutterWebViewPlugin?.dispose();
    print('called dispose');

    super.dispose();
  }

  Future<void> handleUrlChange(String url) async {
    if (mounted) {
      debugPrint('Url has changed $url');

      if (url.contains('success')) {
        final u = Uri.parse(url).queryParameters['data'];
        final result = jsonDecode(u);
        print('$result');
        dispose();

        // Setup appointmentUID to create an appointment document with that ID
        LocatorService.appointmentSetupProvider().setAppoinetmentUID =
            result['appointmentId'];

        // Setup paymentDocUID to have reference for payment document with appointment
        // document
        LocatorService.appointmentSetupProvider().setPaymentDocUID =
            result['paymentDocId'];

        NavigationController.navigator
            .popAndPush(Routes.appointmentSetupController);
        return;
      }

      if (url.contains('error')) {
        dispose();
        Fluttertoast.showToast(
            msg: 'Error occured during payment. Please try again');
        NavigationController.navigator.pop();
        return;
      }

      if (url.contains('failed')) {
        dispose();
        Fluttertoast.showToast(
            msg: 'Error occured during payment. Please try again');
        NavigationController.navigator.pop();
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: Uri.dataFromString(loadHtml(), mimeType: 'text/html').toString(),
      javascriptChannels: jsChannels,
      mediaPlaybackRequiresUserGesture: false,
      appBar: AppBar(
        title: const Text(AppStrings.payment),
        bottom: Progress(
          flutterWebviewPlugin: flutterWebViewPlugin,
        ),
      ),
      withZoom: true,
      withLocalStorage: true,
      // hidden: true,
      initialChild: Container(
        color: Colors.white10,
        child: const Center(
          child: CustomLoader(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                flutterWebViewPlugin.goBack();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                flutterWebViewPlugin.goForward();
              },
            ),
            IconButton(
              icon: const Icon(Icons.autorenew),
              onPressed: () {
                flutterWebViewPlugin.reload();
              },
            ),
          ],
        ),
      ),
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

String selectedUrl = 'https://flutter.io';

// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();
