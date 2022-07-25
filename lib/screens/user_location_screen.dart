import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_project/constants.dart';
import 'package:new_project/model/chat_room_model.dart';
import 'package:new_project/model/user_model.dart';
import 'package:new_project/screens/chat_screen.dart';
import 'package:new_project/utils/firebase_auth_util.dart';
import 'package:new_project/utils/uuid.dart';
import 'package:provider/provider.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({Key? key, required this.targetUser})
      : super(key: key);

  final UserModel targetUser;

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  late GoogleMapController _gMapcontroller;

  double lat = 0.0, long = 0.0;
  bool _isMapCreated = false;

  Future<ChatroomModel?> getChatroomModel(
    UserModel targetUser,
    BuildContext context,
  ) async {
    ChatroomModel? chatRoom;

    User? currUser = context.read<FirebaseAuthUtil>().currentUser;

    print(currUser!.uid);

    print(targetUser.uid);

    ChatroomModel chatroomModel;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .where("participants.${currUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      //CHATROOM EXISTS
      print("chatroom already exists");
      var docData = snapshot.docs[0].data();
      ChatroomModel existingChatroom =
          ChatroomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      //CREATE NEW CHATROOM
      print("no chatroom found");
      chatroomModel = ChatroomModel(
        chatroomId: UUID.uuid.v1(),
        lastMessage: "",
        participants: {
          targetUser.uid.toString(): true,
          currUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatroomModel.chatroomId)
          .set(chatroomModel.toMap());

      chatRoom = chatroomModel;

      print("new chatroom created");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: primaryColor,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.targetUser.name!,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black),
            ),
            const SizedBox(height: 2),
            const Text(
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
            width: double.maxFinite,
            color: Colors.white,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("location")
                  .doc(widget.targetUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (_isMapCreated) updateCamera(lat: lat, long: long);

                if (!snapshot.hasData) {
                  print("NO DATA FOUND");
                  return const Center(child: Text("NO DATA FOUND"));
                } else if (snapshot.hasError) {
                  print("ERROR GETTING DATA");
                  return const Center(child: Text("ERROR GETTING DATA"));
                } else {
                  final data = snapshot.data?.data() as Map<String, dynamic>;

                  print("target lat: ${data["lat"]}");

                  lat = double.parse(data["lat"]);
                  long = double.parse(data["long"]);

                  return GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(lat, long),
                      zoom: 16.66,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("marker_id"),
                        position: LatLng(lat, long),
                      ),
                    },
                    onMapCreated: (controller) {
                      _gMapcontroller = controller;

                      setState(() {
                        _isMapCreated = true;
                      });

                      // updateCamera(lat: lat, long: long);
                    },
                  );
                }
              },
            ),
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
                    leading: CircleAvatar(
                      backgroundColor: primaryColor,
                      backgroundImage:
                          NetworkImage(widget.targetUser.photoUrl ?? ""),
                    ),
                    title: Text(widget.targetUser.name ?? ""),
                    subtitle: const Text("at Tecorb since 10:15"),
                    trailing: IconButton(
                      onPressed: () async {
                        ChatroomModel? chatroomModel =
                            await getChatroomModel(widget.targetUser, context);

                        if (chatroomModel != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chatroom: chatroomModel,
                                firebaseUser: context
                                    .read<FirebaseAuthUtil>()
                                    .currentUser!,
                                targetUser: widget.targetUser,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.message,
                        color: primaryColor,
                      ),
                    ),
                    onTap: () {
                      updateCamera(lat: lat, long: long);
                    },
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
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateCamera({required double lat, required double long}) async {
    print("update camera function");

    await _gMapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 17,
        ),
      ),
    );
  }
}
