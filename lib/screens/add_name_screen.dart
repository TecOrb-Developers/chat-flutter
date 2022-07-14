import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/add_photo_screen.dart';

class AddNameScreen extends StatelessWidget {
  const AddNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "What's your name?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: yellowBtnColor,
                fontSize: 22,
              ),
              cursorColor: yellowBtnColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "First Name",
                hintStyle: TextStyle(color: hintTextColor),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              textAlign: TextAlign.center,
              style: TextStyle(
                color: yellowBtnColor,
                fontSize: 22,
              ),
              cursorColor: yellowBtnColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Last Name",
                hintStyle: TextStyle(color: hintTextColor),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddPhotoScreen()),
                );
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  color: yellowBtnColor,
                  shape: StadiumBorder(),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 21,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
