import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:flutter/material.dart';

class NothingYetPlaceholder extends StatelessWidget {
  const NothingYetPlaceholder({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.nothing ?? '',
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Theme.of(context).disabledColor,
            ),
      ),
    );
  }
}
