import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/add_photo_screen.dart';
import 'package:new_project/screens/share_location_screen.dart';
import 'package:new_project/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNameScreen extends StatelessWidget {
  AddNameScreen({Key? key}) : super(key: key);

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Form(
          key: form,
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
              TextFormField(
                controller: _firstNameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: yellowBtnColor,
                  fontSize: 22,
                ),
                cursorColor: yellowBtnColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "First Name",
                  hintStyle: TextStyle(color: hintTextColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackbar(context, "Both fields are required");
                    return "";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _lastNameController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: yellowBtnColor,
                  fontSize: 22,
                ),
                cursorColor: yellowBtnColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Last Name",
                  hintStyle: TextStyle(color: hintTextColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    showSnackbar(context, "Both fields are required");
                    return "";
                  }
                  return null;
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  if (form.currentState!.validate()) {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    await prefs.setString(nameKey,
                        "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}");

                    if (prefs.getString(photoKey) != null ||
                        prefs.getString(photoKey)!.isNotEmpty) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const ShareLocationScreen()),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const AddPhotoScreen()),
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
