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
      color: Colors.indigo,
      alignment: Alignment.center,
      child: const Text(
        "LOGO",
        style: TextStyle(
          color: Colors.white,
          // fontSize: 18,
          // fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
