import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/screens/user_location_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:provider/provider.dart';

class MapsScreen extends StatelessWidget {
  MapsScreen({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        backgroundColor: primaryColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Colors.indigo,
                      radius: 32,
                    ),
                    Icon(
                      Icons.settings,
                      color: hintTextColor,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  style: ListTileStyle.drawer,
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: hintTextColor,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: tileTextColor, fontSize: 16),
                  ),
                  onTap: () async {
                    await context.read<FirebaseAuthUtil>().signOut();
                  },
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: hintTextColor,
                    size: 17,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              height: constraints.maxHeight / 1.6,
              color: Colors.red,
            );
          }),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "B - 52 sector 63, Noida",
                      style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ],
            ),
          )),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.4, 0.9],
            builder: ((context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: 30,
                      child: const Divider(thickness: 5),
                    ),
                    Expanded(
                      child: ListView.builder(
                          controller: scrollController,
                          // physics: const ClampingScrollPhysics(),
                          itemCount: 21,
                          itemBuilder: (context, index) {
                            if (index == 20) {
                              return const SizedBox(
                                height: 50,
                              );
                            }
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  leading: const CircleAvatar(
                                      backgroundColor: primaryColor),
                                  title: const Text("Test User Name"),
                                  subtitle: const Text("at Tecorb since 10.32"),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const UserLocationScreen()),
                                    );
                                  },
                                ),
                                const Divider(
                                  height: 0,
                                  endIndent: 22,
                                  indent: 22,
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              );
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
              width: double.maxFinite,
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: primaryColor,
                shape: StadiumBorder(),
              ),
              child: const Text(
                "+ Add a new member",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
