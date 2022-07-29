import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
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

  String _myLocationAddress = "";

  double lat = 0.0, long = 0.0;

  final Set<Marker> _markers = {};

  void _startStreaming() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      lat = position?.latitude ?? 0.0;
      long = position?.longitude ?? 0.0;

      FirebaseFirestore.instance
          .collection("location")
          .doc(widget.user.uid)
          .update({
        "lat": position?.latitude.toString() ?? "",
        "long": position?.longitude.toString() ?? "",
      });

      _updatePinOnMap();

      print(position == null
          ? 'Unknown'
          : 'stream positions: ${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  void _updatePinOnMap() {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 18,
      tilt: 20,
      target: LatLng(lat, long),
    );

    _gmapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId("marker_id"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(lat, long),
        consumeTapEvents: false,
      ));
    });
  }

  @override
  void initState() {
    lat = widget.position.latitude;
    long = widget.position.longitude;
    _initialLatLng = LatLng(
      lat,
      long,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialLatLng,
            tilt: 10,
            zoom: 10,
          ),
          markers: _markers,
          compassEnabled: false,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) async {
            _completer.complete(controller);
            _gmapController = controller;

            print("on map created...");

            _myLocationAddress = await _getAddressFromCoord(lat, long);

            setState(() {
              _markers.clear();
              _markers.add(Marker(
                markerId: const MarkerId("marker_id"),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
                position: LatLng(lat, long),
                consumeTapEvents: false,
              ));

              _startStreaming();
            });
          },
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
                      child: Text(
                        _myLocationAddress,
                        style: const TextStyle(
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

                    _gmapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(position.latitude, position.longitude),
                          tilt: 10,
                          zoom: 18,
                        ),
                      ),
                    );
                    setState(() {});
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
          ),
        ),
      ],
    );
  }

  Future<String> _getAddressFromCoord(double lat, double long) async =>
      await placemarkFromCoordinates(lat, long).then((placemarks) =>
          "${placemarks[0].name} ${placemarks[0].subLocality}, ${placemarks[0].locality}");

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
