import 'package:flutter/material.dart';
import 'package:new_project/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_project/screens/maps_screen.dart';

class ShareLocationScreen extends StatefulWidget {
  const ShareLocationScreen({Key? key}) : super(key: key);

  @override
  State<ShareLocationScreen> createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  late final Position? position;
  bool _isLoading = true;

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
      // return Future.error('Location services are disabled.');
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
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  void getPosition() async {
    position = await _determinePosition();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              "assets/images/maps_share.png",
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Share your location with us",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Trackmatt requires these\npermissions to work",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const Spacer(flex: 2),
            GestureDetector(
              onTap: _isLoading
                  ? null
                  : () {
                      if (position != null) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => MapsScreen(position: position!),
                          ),
                          (route) => false,
                        );
                      }
                    },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                width: double.maxFinite,
                alignment: Alignment.center,
                decoration: const ShapeDecoration(
                  color: yellowBtnColor,
                  shape: StadiumBorder(),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Share",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
