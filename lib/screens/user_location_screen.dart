import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/chat_screen.dart';

class UserLocationScreen extends StatelessWidget {
  const UserLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: PRIMARY_COLOR,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Test User Name",
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            ),
            SizedBox(height: 2),
            Text(
              "Location Sharing Started",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight * 0.65,
            color: Colors.red,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.28,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const CircleAvatar(backgroundColor: PRIMARY_COLOR),
                    title: const Text("Test User Name"),
                    subtitle: const Text("at Tecorb since 10:15"),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ChatScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.message,
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 0.5,
                    endIndent: 19,
                    indent: 19,
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    leading: Icon(
                      Icons.directions,
                      color: Colors.grey,
                    ),
                    title: Text("Get Directions"),
                    subtitle: Text("100 miles away"),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
