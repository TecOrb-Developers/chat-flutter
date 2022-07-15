import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/add_name_screen.dart';
import 'package:new_project/screens/share_location_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: primaryColor,
                size: 28,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Welcome Stranger!",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              const CircleAvatar(
                backgroundColor: primaryColor,
                backgroundImage: AssetImage("assets/images/avatar.png"),
                maxRadius: 50,
                // child: Image.asset("assets/images/avatar.png"),
              ),
              const SizedBox(height: 30),
              const Text(
                "Please login to continue to the",
                // style: TextStyle(
                //   fontSize: 19,
                //   fontWeight: FontWeight.w600,
                // ),
              ),
              const Text(
                "Awesomeness",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 80),
              //login buttons
              Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("fb login");
                            context.read<FirebaseAuthUtil>().signInWithFb();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 1),
                            height: 130,
                            color: Colors.blue,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.facebookF,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: const TextSpan(
                                    text: "Login with ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Facebook",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            print("google login");
                            await context
                                .read<FirebaseAuthUtil>()
                                .signInWithGoogle();

                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            String email = prefs.getString(emailKey) ?? "";
                            String name = prefs.getString(nameKey) ?? "";
                            String photo = prefs.getString(photoKey) ?? "";

                            if (name.isEmpty) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const AddNameScreen()),
                              );
                            } else if (photo.isEmpty) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const AddNameScreen()),
                              );
                            } else {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ShareLocationScreen()),
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 1),
                            height: 130,
                            color: Colors.red,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: const TextSpan(
                                    text: "Login with ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Google",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    heightFactor: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text("OR", style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
