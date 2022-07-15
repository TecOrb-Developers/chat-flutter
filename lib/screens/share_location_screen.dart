import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/maps_screen.dart';

class ShareLocationScreen extends StatelessWidget {
  const ShareLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            size: 28,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            "assets/images/maps_share.png",
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            "Share your location with us",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Trackmatt requires these\npermissions to work",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MapsScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: yellowBtnColor,
                shape: StadiumBorder(),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
