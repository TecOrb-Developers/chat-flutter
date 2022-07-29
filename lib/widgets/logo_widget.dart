import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      alignment: Alignment.center,
      child: Image.asset("assets/images/splash_logo.jpeg"),
    );
  }
}
