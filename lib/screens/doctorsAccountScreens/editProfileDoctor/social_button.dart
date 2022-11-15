import 'package:flutter/material.dart';

class AuthSocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String socialName;
  final String imagePath;
  final Color backGroundColor;
  final Color textColor;
  final double elevation;

  const AuthSocialButton(
      {Key key,
      this.onPressed,
      this.socialName,
      this.imagePath,
      this.backGroundColor,
      this.textColor,
      this.elevation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imagePath,
                color: Colors.green,
              ),
              Text(
                socialName,
                style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          )),
    ));
  }
}
