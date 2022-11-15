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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/shared/animatedButton.dart';
import 'package:doctor_consultation/shared/customButtonStyle.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewStateSelector<T extends BaseProvider> extends StatelessWidget {
  const ViewStateSelector({
    Key key,
    @required this.child,
    @required this.getData,
    this.isDataAvailable = false,
  }) : super(key: key);

  final Widget child;
  final Function getData;
  final bool isDataAvailable;

  @override
  Widget build(BuildContext context) {
    return Selector<T, ViewState>(
      selector: (context, d) => d.state,
      shouldRebuild: (a, b) => true,
      builder: (context, viewState, _) {
        viewState = isDataAvailable ? ViewState.DATA : viewState;
        switch (viewState) {
          case ViewState.LOADING:
            // Call the get data function
            getData();
            return const CustomLoader();
            break;

          case ViewState.ERROR:
            return ErrorContainer<T>();
            break;

          case ViewState.DATA:
            return child;
            break;

          case ViewState.NO_DATA_AVAILABLE:
            return NoDataAvailable<T>();
            break;

          default:
            return ErrorContainer<T>();
        }
      },
    );
  }
}

class NoDataAvailable<T extends BaseProvider> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final T ref = locator<T>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              AppStrings.noDataAvailable,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            AnimButton(
              child: CustomButtonStyle(
                color: _theme.disabledColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(AppStrings.reload,
                      style: Theme.of(context).textTheme.button),
                ),
              ),
              onTap: () {
                ref.notifyLoading();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorContainer<T extends BaseProvider> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final T ref = locator<T>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              ref.error ?? AppStrings.somethingWentWrong,
              style: _theme.textTheme.headline6.copyWith(
                color: _theme.errorColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            AnimButton(
              child: CustomButtonStyle(
                color: _theme.disabledColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    AppStrings.reload,
                    style: _theme.textTheme.button,
                  ),
                ),
              ),
              onTap: () {
                ref.notifyLoading();
              },
            ),
          ],
        ),
      ),
    );
  }
}
