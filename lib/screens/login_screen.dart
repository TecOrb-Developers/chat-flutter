import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/add_email_screen.dart';
import 'package:new_project/screens/share_location_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_name_screen.dart';
import 'add_photo_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Column(
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
                              onTap: () async {
                                print("fb login");
                                _toggleLoading();
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //       builder: (_) => const AddEmailScreen()),
                                // );
                                // await context
                                //     .read<FirebaseAuthUtil>()
                                //     .signInWithFb();

                                // final SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();

                                // String email = prefs.getString(emailKey) ?? "";
                                // String name = prefs.getString(nameKey) ?? "";
                                // String photo = prefs.getString(photoKey) ?? "";

                                // if (email.isNotEmpty &&
                                //     name.isNotEmpty &&
                                //     photo.isNotEmpty) {
                                //   _toggleLoading();
                                //   Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (_) =>
                                //             const ShareLocationScreen()),
                                //   );
                                // } else if (email.isEmpty) {
                                //   _toggleLoading();

                                //   Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (_) => const AddEmailScreen()),
                                //   );
                                // } else {
                                //   if (name.isEmpty) {
                                //     _toggleLoading();

                                //     Navigator.of(context).pushReplacement(
                                //       MaterialPageRoute(
                                //           builder: (_) => AddNameScreen()),
                                //     );
                                //   } else if (photo.isEmpty) {
                                //     _toggleLoading();
                                //     Navigator.of(context).pushReplacement(
                                //       MaterialPageRoute(
                                //           builder: (_) =>
                                //               const AddPhotoScreen()),
                                //     );
                                //   }
                                // }
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
                                _toggleLoading();
                                print("google login");
                                await context
                                    .read<FirebaseAuthUtil>()
                                    .signInWithGoogle();

                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                String email = prefs.getString(emailKey) ?? "";
                                String name = prefs.getString(nameKey) ?? "";
                                String photo = prefs.getString(photoKey) ?? "";

                                if (email.isNotEmpty &&
                                    name.isNotEmpty &&
                                    photo.isNotEmpty) {
                                  _toggleLoading();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ShareLocationScreen()),
                                  );
                                } else if (email.isEmpty) {
                                  _toggleLoading();

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => const AddEmailScreen()),
                                  );
                                } else {
                                  if (name.isEmpty) {
                                    _toggleLoading();

                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => AddNameScreen()),
                                    );
                                  } else if (photo.isEmpty) {
                                    _toggleLoading();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const AddPhotoScreen()),
                                    );
                                  }
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
                          child:
                              const Text("OR", style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (_isLoading)
            SafeArea(
              child: Container(
                // height: double.infinity,
                // width: double.infinity,
                color: Colors.transparent,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(10),
                child: const CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            ),
        ],
      ),
    ));
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }
}
