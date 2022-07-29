import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/widgets/logo_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Spacer(flex: 4),
              LogoWidget(),
              SizedBox(height: 20),
              Text(
                "T R A C K M A T T",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(flex: 5),
              Text(
                "All rights reserved to @Tecorb.com",
                style: TextStyle(color: Color.fromARGB(255, 150, 129, 237)),
              ),
              SizedBox(height: 10),
            ]),
      ),
    );
  }
}
