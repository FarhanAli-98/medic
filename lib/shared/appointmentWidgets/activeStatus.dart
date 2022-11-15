import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:flutter/material.dart';

class ActiveStatus extends StatelessWidget {
  const ActiveStatus({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Color color = Colors.green;
    return Row(
      children: <Widget>[
        Text(
          AppStrings.active,
          style: Theme.of(context).textTheme.bodyText2.copyWith(color: color),
        ),
        const SizedBox(width: 5),
        Icon(
          Icons.check,
          color: color,
          size: 20.0,
        ),
      ],
    );
  }
}
