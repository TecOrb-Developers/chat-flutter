import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants.dart';

class MyLocationWidget extends StatefulWidget {
  final Position position;
  final User user;
  const MyLocationWidget({
    Key? key,
    required this.position,
    required this.user,
  }) : super(key: key);

  @override
  State<MyLocationWidget> createState() => _MyLocationWidgetState();
}

class _MyLocationWidgetState extends State<MyLocationWidget> {
  late final LatLng _initialLatLng;
  final Completer<GoogleMapController> _completer = Completer();

  late GoogleMapController _gmapController;

  late StreamSubscription<Position> positionStream;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _startStreaming() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print("latitude : ${position?.latitude.toString()}");
      print("longitude : ${position?.longitude.toString()}");
      FirebaseFirestore.instance
          .collection("location")
          .doc(widget.user.uid)
          .update({
        "lat": position?.latitude.toString() ?? "",
        "long": position?.longitude.toString() ?? "",
      });
      print(position == null
          ? 'Unknown'
          : 'stream positions: ${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  @override
  void initState() {
    _initialLatLng = LatLng(
      widget.position.latitude,
      widget.position.longitude,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialLatLng,
              tilt: 10,
              zoom: 10,
            ),
            compassEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _completer.complete(controller);
              _gmapController = controller;

              print("on map created called");

              _startStreaming();
            },
            onCameraMove: (position) {},
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.transparent,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print("search bar");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
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
                ),
                InkWell(
                  onTap: () async {
                    print('my location button');
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.bestForNavigation,
                    );
                    print("got the position");
                    _gmapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          tilt: 10,
                          zoom: 17,
                        ),
                      ),
                    );
                    setState(() {});
                    print("animate to my location");
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.my_location_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // void _currentLocation() async {
  //  final GoogleMapController controller = await _completer.future;
  //  LocationData currentLocation;
  //  var location = new Location();
  //  try {
  //    currentLocation = await location.getLocation();
  //    } on Exception {
  //      currentLocation = null;
  //      }

  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(
  //       bearing: 0,
  //       target: LatLng(currentLocation.latitude, currentLocation.longitude),
  //       zoom: 17.0,
  //     ),
  //   ));
  // }

  @override
  void dispose() {
    _gmapController.dispose();
    positionStream.cancel();
    super.dispose();
  }
}
