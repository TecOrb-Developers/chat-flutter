import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/add_name_screen.dart';
import 'package:new_project/screens/add_photo_screen.dart';
import 'package:new_project/screens/share_location_screen.dart';
import 'package:new_project/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEmailScreen extends StatelessWidget {
  const AddEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Enter your email",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: emailController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: yellowBtnColor,
                  fontSize: 22,
                ),
                cursorColor: yellowBtnColor,
                maxLines: 1,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "abc@xyz.com",
                  hintStyle: TextStyle(color: hintTextColor),
                ),
                validator: (value) {
                  // Check if this field is empty
                  if (value == null || value.isEmpty) {
                    showSnackbar(context, "This is a required field");
                    return "";
                  }

                  // using regular expression
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    showSnackbar(context, "Please enter a valid email address");
                    return "";
                  }

                  // the email is valid
                  return null;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  if (form.currentState!.validate()) {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.setString(
                        emailKey, emailController.text.trim());

                    if (prefs.getString(nameKey) == null ||
                        prefs.getString(nameKey)!.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => AddNameScreen()),
                      );
                    } else if (prefs.getString(phoneKey) == null ||
                        prefs.getString(photoKey)!.isEmpty) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const AddPhotoScreen()),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const ShareLocationScreen()),
                      );
                    }
                  }
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
      ),
    );
  }
}
