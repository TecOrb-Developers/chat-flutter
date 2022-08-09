import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/screens/onboarding_screen_1.dart';
import 'package:new_project/screens/test_file.dart';
import 'package:new_project/screens/user_location_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:provider/provider.dart';
import '../utils/utils.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key, required this.position}) : super(key: key);

  final Position position;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final CollectionReference _collection =
      FirebaseFirestore.instance.collection("user detail");

  @override
  Widget build(BuildContext context) {
    print("maps screen build method called");
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[200],
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
                      // backgroundImage: NetworkImage(_imageUrl),
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
                    _scaffoldKey.currentState!.closeDrawer();

                    if (await context.read<FirebaseAuthUtil>().signOut()) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const OnboardingScreen()),
                          (route) => false);
                    }
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
              height: constraints.maxHeight / 1.39,
              width: double.maxFinite,
              color: Colors.white,
              child: TestLocationWidget(
                position: widget.position,
                user: context.read<FirebaseAuthUtil>().currentUser!,
              ),
            );
          }),

          // TOP ROW
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      margin: const EdgeInsets.only(top: 2.6),
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
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.4, 0.85],
            builder: (context, scrollController) {
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
                      child: const Divider(
                        thickness: 5,
                        height: 0,
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _collection.snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              final docs = snapshot.data!.docs;

                              return ScrollConfiguration(
                                behavior: Behaviour(),
                                child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: docs.length,
                                    itemBuilder: (context, index) {
                                      print(docs.length);
                                      final DocumentSnapshot doc = docs[index];

                                      Map<String, dynamic> tUser =
                                          doc.data() as Map<String, dynamic>;
                                      UserModel targetUser =
                                          UserModel.fromMap(tUser);

                                      if (doc["uid"] !=
                                          context
                                              .read<FirebaseAuthUtil>()
                                              .currentUser!
                                              .uid) {
                                        if (index == 0) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                  left: 20,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  "People",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                leading: CircleAvatar(
                                                  backgroundColor: primaryColor,
                                                  backgroundImage: NetworkImage(
                                                      doc["photoUrl"]),
                                                  // child:
                                                  //     Image.network(doc["photoUrl"]),
                                                ),
                                                title: Text(doc["name"]),
                                                subtitle: Text(doc["email"]),
                                                onTap: () async {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          UserLocationScreen(
                                                        targetUser: targetUser,
                                                      ),
                                                    ),
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
                                        }
                                        return Column(
                                          children: [
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              leading: CircleAvatar(
                                                backgroundColor: primaryColor,
                                                backgroundImage: NetworkImage(
                                                    doc["photoUrl"]),
                                                // child:
                                                //     Image.network(doc["photoUrl"]),
                                              ),
                                              title: Text(doc["name"]),
                                              subtitle: Text(doc["email"]),
                                              onTap: () async {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        UserLocationScreen(
                                                      targetUser: targetUser,
                                                    ),
                                                  ),
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
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    }),
                              );
                            }
                            return const Scaffold(
                              backgroundColor: Colors.white,
                              body: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
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
          ),
          Visibility(
            visible: context.watch<FirebaseAuthUtil>().hasLoggedOut,
            child: Scaffold(
              backgroundColor: Colors.grey[50]!.withOpacity(0.2),
              body: const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void readMembers() async {
    print("read members called");
    // FirebaseFirestore.instance.collection("users").doc();
    var list = FirebaseFirestore.instance.collection("users").snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList());

    print("got the list");

    var first = await list.first;

    print(first[0].email);

    // final docRef = FirebaseFirestore.instance
    //     .collection("users")
    //     .doc("7PujGzMZhEYVzbuYmfvr");

    // docRef.get().then(
    //   (doc) {
    //     final data = doc.data() as Map<String, dynamic>;

    //     data.forEach((key, value) {
    //       print("$key -> $value");
    //     });
    //   },
    //   onError: (e) => print("Error getting document: $e"),
    // );

    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");

    collection.snapshots;
  }
}
