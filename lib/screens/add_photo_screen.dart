import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/share_location_screen.dart';

class AddPhotoScreen extends StatelessWidget {
  const AddPhotoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Add your photo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "This makes it easy for your family to\nfind you on the map",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const Spacer(flex: 4),
            // const SizedBox(height: 30),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[200],
                  maxRadius: 40,
                  child: const Text("Profile\npic"),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  decoration: const ShapeDecoration(
                    color: yellowBtnColor,
                    shape: StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt_sharp,
                        size: 19,
                        color: PRIMARY_COLOR,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Add your photo",
                        style: TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(flex: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const ShareLocationScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  color: yellowBtnColor,
                  shape: StadiumBorder(),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Skip",
                style: TextStyle(color: yellowBtnColor, fontSize: 12),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
