import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as maps;
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
  final Completer<GoogleMapController> _completer = Completer();
  late GoogleMapController _gMapcontroller;
  bool _isOpen = true;

  double lat = 0.0, long = 0.0, distance = 0.0;
  // bool _isMapCreated = false;
  late Position myPosition;

  // final Set<Marker> _markers = {};

  Future<ChatroomModel?> getChatroomModel(
    UserModel targetUser,
    BuildContext context,
  ) async {
    ChatroomModel? chatRoom;

    User? currUser = context.read<FirebaseAuthUtil>().currentUser;

    print(currUser!.uid);

    print(targetUser.uid);

    // ChatroomModel chatroomModel;

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
      ChatroomModel? newChatRoom = ChatroomModel(
        chatroomId: UUID.uuid.v1(),
        lastMessage: "",
        participants: {
          targetUser.uid.toString(): true,
          currUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatroomId)
          .set(newChatRoom.toMap());

      print("new chatroom created");

      chatRoom = newChatRoom;
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
            height: screenHeight * 0.73,
            width: double.maxFinite,
            color: Colors.white,
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("location")
                  .doc(widget.targetUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                print("snapshot builder");
                if (!snapshot.hasData) {
                  return const Center(child: Text("LOADING..."));
                } else if (snapshot.hasError) {
                  return const Center(child: Text("ERROR GETTING DATA"));
                } else {
                  final data = snapshot.data?.data() as Map<String, dynamic>;

                  lat = double.parse(data["lat"]);
                  long = double.parse(data["long"]);

                  // if (_isMapCreated) updateCamera(lat: lat, long: long);

                  return Animarker(
                    mapId: _completer.future.then<int>((value) => value.mapId),
                    markers: {
                      Marker(
                        markerId: const MarkerId("marker_id"),
                        position: LatLng(lat, long),
                        draggable: false,
                      ),
                    },
                    child: GoogleMap(
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, long),
                        zoom: 20,
                      ),
                      // markers: _markers,
                      onMapCreated: (controller) async {
                        _completer.complete(controller);
                        _gMapcontroller = controller;

                        myPosition = await Geolocator.getCurrentPosition();

                        distance = Geolocator.distanceBetween(
                          myPosition.latitude,
                          myPosition.longitude,
                          lat,
                          long,
                        );

                        setState(() {
                          // _isMapCreated = true;
                          // _markers.clear();
                          // _markers.add(
                          //   Marker(
                          //     markerId: const MarkerId("marker_id"),
                          //     position: LatLng(lat, long),
                          //   ),
                          // );
                        });

                        // updateCamera(lat: lat, long: long);
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.2,
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
                  // const Spacer(),
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
                        if (_isOpen) {
                          _isOpen = false;
                          await getChatroomModel(widget.targetUser, context)
                              .then((chatroomModel) async {
                            if (chatroomModel != null) {
                              if (!mounted) return;
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
                              Future.delayed(const Duration(seconds: 1),
                                  () => _isOpen = true);
                            }
                          });
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
                    height: 0,
                    // thickness: 0.5,
                    endIndent: 19,
                    indent: 19,
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    leading: const Icon(
                      Icons.directions,
                      color: Colors.grey,
                    ),
                    title: const Text("Get Directions"),
                    subtitle: Text(
                      "${(distance.toInt() * 0.001).toStringAsFixed(3)} km from ${widget.targetUser.name}",
                    ),
                    onTap: () async {
                      if (Platform.isIOS) {
                        if (await maps.MapLauncher.isMapAvailable(
                                maps.MapType.google) ??
                            false) {
                          maps.MapLauncher.showDirections(
                              mapType: maps.MapType.google,
                              destination: maps.Coords(lat, long));
                        } else {
                          maps.MapLauncher.showDirections(
                              mapType: maps.MapType.apple,
                              destination: maps.Coords(lat, long));
                        }
                      } else {
                        maps.MapLauncher.showDirections(
                            mapType: maps.MapType.google,
                            destination: maps.Coords(lat, long));
                      }
                    },
                  ),
                  const Spacer(flex: 3),
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

    _gMapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, long),
          zoom: 17,
        ),
      ),
    );

    // _markers.clear();
    // _markers.add(
    //   Marker(
    //     markerId: const MarkerId("marker_id"),
    //     position: LatLng(lat, long),
    //   ),
    // );

    // setState(() {});  //PENDING: another test to be done without set state...
  }
}
