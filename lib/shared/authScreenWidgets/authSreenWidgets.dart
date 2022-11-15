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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/authProvider.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/forgotPasswordForm.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/shared/animatedButton.dart';
import 'package:doctor_consultation/shared/customButtonStyle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'lib/assets/images/bag.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key key,
    @required this.title,
    this.body,
  }) : super(key: key);

  final String title, body;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: _theme.textTheme.headline6.copyWith(
              color: _theme.primaryColorDark,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            style: _theme.textTheme.bodyText1.copyWith(
              color: _theme.primaryColorDark,
            ),
          ),
        ],
      ),
    );
  }
}

class FooterQuestion extends StatelessWidget {
  const FooterQuestion({
    Key key,
    @required this.questionText,
    @required this.buttonLable,
    @required this.onPress,
  }) : super(key: key);

  final String questionText, buttonLable;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            questionText,
            style: _theme.textTheme.caption,
          ),
          const SizedBox(height: 5),
          FlatButton(
            color: _theme.primaryColor.withOpacity(0.2),
            child: Text(
              buttonLable,
              style: _theme.textTheme.button.copyWith(
                color: _theme.primaryColor,
              ),
            ),
            onPressed: () {
              // Removes the keyborad
              FocusScope.of(context).unfocus();
              onPress();
            },
          ),
        ],
      ),
    );
  }
}

class Submit extends StatelessWidget {
  const Submit({
    Key key,
    @required this.isLoading,
    @required this.onPress,
    @required this.lable,
  }) : super(key: key);

  final bool isLoading;
  final Function onPress;
  final String lable;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: isLoading
          ? const Loading()
          : AnimButton(
              onTap: () {
                // Removes the keyborad
                FocusScope.of(context).unfocus();
                onPress();
              },
              child: CustomButtonStyle(
                color: _theme.primaryColorLight.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    lable ?? '',
                    style:
                        _theme.textTheme.button.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
    );
  }
}

class ShowError extends StatelessWidget {
  const ShowError({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    if (text.isEmpty) {
      return const SizedBox(height: 20);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          text,
          style: _theme.textTheme.caption.copyWith(
            color: Colors.red.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Center(
        child: SpinKitCircle(
          color: Colors.black,
          duration: Duration(seconds: 1),
        ),
      ),
    );
  }
}

class DoctorAccountSwitcher extends StatelessWidget {
  const DoctorAccountSwitcher({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2 / 2.5,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: ThemeGuide.borderRadius16,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'lib/assets/svg/doctor.svg',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              color: _theme.primaryColor.withOpacity(0.6),
              child: const Text(AppStrings.iamDoctor),
              onPressed: () {
                NavigationController.navigator.replace(Routes.loginDoctor);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NormalAccountSwitcher extends StatelessWidget {
  const NormalAccountSwitcher({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2 / 2.5,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: ThemeGuide.borderRadius16,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'lib/assets/svg/rash.svg',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton(
              color: _theme.primaryColor.withOpacity(0.6),
              child: const Text(AppStrings.iamNotDoctor),
              onPressed: () {
                NavigationController.navigator.replace(Routes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => UiController.showModal(context, const ForgotPasswordForm()),
      child: const Text(
        AppStrings.forgotPassword,
        style: TextStyle(color: Color(0xFF64B5F6)),
      ),
    );
  }
}

class LoginMessageTop extends StatelessWidget {
  const LoginMessageTop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          'Scroll down for more options',
          style: Theme.of(context)
              .textTheme
              .bodyText2
              .copyWith(color: Colors.black26),
        ),
      ),
    );
  }
}

class SocialLoginLoadingOverlay extends StatelessWidget {
  const SocialLoginLoadingOverlay({
    Key key,
    @required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UIAuthProvider>.value(
      value: LocatorService.uiAuthProvider(),
      child: Stack(
        children: <Widget>[
          child,
          Selector<UIAuthProvider, bool>(
            selector: (context, d) => d.socialLoginLoading,
            builder: (BuildContext context, bool value, Widget _) {
              if (value) {
                return Container(
                  color: Colors.black12.withAlpha(100),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      padding: ThemeGuide.padding20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: ThemeGuide.borderRadius10,
                      ),
                      child: const CustomLoader(),
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
